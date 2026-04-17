require "aws-sdk-s3"
require "json"
require "honeybadger"

namespace :import do
  desc "Import MOVEMENT events from latest S3 JSON file"
  task movement_from_s3: :environment do
    begin
      city   = "movement"
      bucket = "movement-parties-events-data"
      prefix = "events/"

      s3 = Aws::S3::Client.new(region: "us-east-1")

      files = s3.list_objects_v2(bucket: bucket, prefix: prefix).contents
      if files.empty?
        puts "No S3 JSON files found!"
        exit
      end

      latest_file = files.max_by(&:last_modified)
      filename = latest_file.key
      puts "Downloading latest file: #{filename}"

      temp_path = "/tmp/#{filename.split('/').last}"
      s3.get_object(bucket: bucket, key: filename, response_target: temp_path)

      events = JSON.parse(File.read(temp_path))

      created_count = 0
      updated_count = 0
      matched_events = []

      skip_title = lambda do |title|
        t = title.to_s.downcase
        t.include?("pass") || t.include?("multi-day") || t.include?("week pass") || t.include?("festival pass")
      end

      skip_urls = [
        "https://ra.co/events/2370518",
        "https://ra.co/events/2353591",
        "https://ra.co/events/2393835",
        "https://ra.co/events/2400579"
      ]

      events.each_with_index do |event_data, index|
        event_info = event_data["event"]
        next unless event_info

        event_url = "https://ra.co#{event_info['contentUrl']}"
        next if skip_urls.include?(event_url)

        title = event_info["title"].to_s.strip
        next if skip_title.call(title)

        begin
          ActiveRecord::Base.transaction do
            venue_name = (event_info.dig("venue", "name") || "Unknown Venue")
                          .to_s.strip.gsub(/\s+/, " ")

            venue = Venue.where(city_key: city)
                         .where("lower(name) = ?", venue_name.downcase)
                         .order(Arel.sql("(bg_color IS NOT NULL)::int + (font_color IS NOT NULL)::int + (address IS NOT NULL)::int + (location IS NOT NULL)::int + (image_filename IS NOT NULL)::int DESC"))
                         .first

            venue ||= Venue.create!(city_key: city, name: venue_name)

            genres =
              if event_info["genres"].is_a?(Array) && event_info["genres"].any?
                event_info["genres"].map { |g| Genre.find_or_create_by_canonical_name!(g["name"]) }
              else
                []
              end

            event = Event.find_by_any_source_url(city, event_url) ||
                    Event.find_or_initialize_by(city_key: city, event_url: event_url)
            is_new = event.new_record?

            images = event_info["images"] || []
            flyer_front = images.find { |img| img["type"] == "FLYERFRONT" }
            event_image_url = flyer_front&.dig("filename") || images.first&.dig("filename")


            attrs = {
              source: "RA",
              attending_count: event_info["attending"] || 0,
              event_image_url: event_image_url,
              city_key: city,
              event_url: event_url,
              ra_url: event_url
            }
            attrs[:title]      = event_info["title"]     unless event.manual_override_title
            attrs[:start_time] = event_info["startTime"] unless event.manual_override_times
            attrs[:end_time]   = event_info["endTime"]   unless event.manual_override_times
            attrs[:venue]      = venue                   unless event.manual_override_location

            attrs.delete(:short_title) # never overwrite from imports
            event.assign_attributes(attrs)
            event.save!
            ticket_info = event_data["ticket_info"] || {}

            raw_price = ticket_info["price"]&.to_s&.split("+")&.first&.strip
            raw_price = nil if raw_price.blank? || raw_price.downcase == "null"

            ra_ticket_price =
              begin
                raw_price ? BigDecimal(raw_price.delete("$,")) : nil
              rescue ArgumentError
                nil
              end

            ra_ticket_status = ticket_info["status"].presence
            ra_ticket_on_sale_at =
              begin
                ticket_info["on_sale_at"].present? ? Time.zone.parse(ticket_info["on_sale_at"]) : nil
              rescue ArgumentError, TypeError
                nil
              end

            ra_has_ticketing =
              ra_ticket_status.present? ||
              ticket_info["tier"].present? ||
              ticket_info["current_tier"].present? ||
              !ra_ticket_price.nil?

            ra_is_free_ticketing =
              ra_has_ticketing && ra_ticket_price == 0

            update_attrs = {
              ra_ticket_status: ra_ticket_status,
              ra_ticket_on_sale_at: ra_ticket_on_sale_at,
              ra_has_ticketing: ra_has_ticketing,
              ra_is_free_ticketing: ra_is_free_ticketing
            }

            unless event.manual_override_ticket
              update_attrs.merge!(
                ticket_tier: ticket_info["tier"],
                ticket_price: ra_ticket_price,
                ticket_wave: ticket_info["current_tier"]
              )
            end

            event.update!(update_attrs)

            event.genres = genres unless event.manual_override_genres

            if event_info["artists"] && !event.manual_override_artists
              event_info["artists"].each do |artist_data|
                artist = Artist.find_or_create_by_canonical_name!(artist_data["name"])
                event.artists << artist if artist && !event.artists.include?(artist)
              end
            end

            if is_new
              created_count += 1
            else
              updated_count += 1
              matched_events << { title: event.title, id: event.id, match_type: "url" }
            end
          end
        rescue => e
          puts "Error importing event at index #{index}: #{e.message}"
          Honeybadger.notify(e)
        end
      end

      Event.clear_public_index_cache!("movement")
      puts "Finished importing Movement events from #{filename}"
      puts "Created: #{created_count}"
      puts "Updated: #{updated_count}"
      if matched_events.any?
        puts "\nMatched (duplicates - updated existing):"
        matched_events.each { |m| puts "  #{m[:title]} (#{m[:id]}) [#{m[:match_type]}]" }
      end
      Honeybadger.notify("Movement import succeeded: created=#{created_count}, updated=#{updated_count} from #{filename}")
    rescue => e
      Honeybadger.notify(e)
      raise e
    end
  end
  end
