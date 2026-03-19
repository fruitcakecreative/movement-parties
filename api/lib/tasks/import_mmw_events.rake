# lib/tasks/import_mmw_from_s3.rake
require "aws-sdk-s3"
require "json"
require "honeybadger"
require "bigdecimal"
require_relative "../import_helpers"

namespace :import do
  desc "Import MMW events from latest S3 JSON file"
  task mmw_from_s3: :environment do
    begin
      city   = "mmw"
      bucket = "mmw-parties-events-data"
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
      created_events = []
      matched_events = []

      skip_title = lambda do |title|
        t = title.to_s.downcase
        t.include?("pass") || t.include?("multi-day") || t.include?("week pass") || t.include?("festival pass")
      end

      skip_urls = [
        "https://ra.co/events/2370518",
        "https://ra.co/events/2353591",
        "https://ra.co/events/2362100",
        "https://ra.co/events/2386966",
        "https://ra.co/events/2386842",
        "https://ra.co/events/2387406",
        "https://ra.co/events/2388414",
        "https://ra.co/events/2377327",
        "https://ra.co/events/2352453",
        "https://ra.co/events/2356992",
        "https://ra.co/events/2358160",
        "https://ra.co/events/2385322",
        "https://ra.co/events/2347797",
        "https://ra.co/events/2347782",
        "https://ra.co/events/2359823",
        "https://ra.co/events/2379874",
        "https://ra.co/events/2370232",
        "https://ra.co/events/2370161",
        "https://ra.co/events/2390840"
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

            venue = ImportHelpers.find_venue(city: city, venue_name: venue_name)
            venue ||= Venue.create!(city_key: city, name: venue_name)

            genres =
              if event_info["genres"].is_a?(Array) && event_info["genres"].any?
                event_info["genres"].map { |g| Genre.find_or_create_by_canonical_name!(g["name"]) }
              else
                []
              end

            event = Event.find_by_any_source_url(city, event_url)
            match_type = "url" if event.present?

            if event.nil?
              start_time = event_info["startTime"].present? ? Time.zone.parse(event_info["startTime"]) : nil
              incoming_title = event_info["title"].to_s.strip
              if venue && start_time.present? && incoming_title.present?
                candidates = Event.where(city_key: city, venue_id: venue.id)
                  .where("start_time >= ? AND start_time < ?", start_time - 1.minute, start_time + 1.minute)
                strict_title = ImportHelpers.venue_requires_strict_title?(venue)
                event = candidates.find do |c|
                  strict_title ? (incoming_title.to_s.strip.downcase == c.title.to_s.strip.downcase) : ImportHelpers.title_words_match?(incoming_title, c.title)
                end
                match_type = "venue_time_title" if event.present?
              end
              event ||= Event.new(city_key: city, event_url: event_url)
            end

            is_new = event.new_record?
            dice_backed = event.dice_url.present?

            images = event_info["images"] || []
            flyer_front = images.find { |img| img["type"] == "FLYERFRONT" }
            event_image_url = flyer_front&.dig("filename") || images.first&.dig("filename")

            attrs = {
              source: "RA",
              attending_count: event_info["attending"] || 0,
              city_key: city,
              event_url: event_url,
              ra_url: event_url
            }

            attrs[:title] = event_info["title"] unless event.manual_override_title
            attrs[:start_time] = event_info["startTime"] unless event.manual_override_times
            attrs[:end_time] = event_info["endTime"] unless event.manual_override_times
            attrs[:venue] = venue unless event.manual_override_location

            # Only let RA own image if the event is not DICE-backed
            if !dice_backed && event_image_url.present?
              attrs[:event_image_url] = event_image_url
            end

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

            # Only let RA own ticket fields if the event is not DICE-backed
            unless event.manual_override_ticket || dice_backed
              update_attrs[:ticket_tier] = ticket_info["tier"] if ticket_info["tier"].present?
              update_attrs[:ticket_wave] = ticket_info["current_tier"] if ticket_info["current_tier"].present?
              update_attrs[:ticket_price] = ra_ticket_price unless ra_ticket_price.nil?
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
              created_events << { title: event.title, id: event.id, venue: venue&.name }
            else
              updated_count += 1
              matched_events << { title: event.title, id: event.id, match_type: match_type || "url" }
            end
          end
        rescue => e
          puts "Error importing event at index #{index}: #{e.message}"
          Honeybadger.notify(e)
        end
      end

      Rails.cache.delete("events-v1:mmw") rescue nil
      puts "Finished importing MMW events from #{filename}"
      puts "Created: #{created_count}"
      puts "Updated: #{updated_count}"
      if created_events.any?
        puts "\nCreated (new):"
        created_events.each { |e| puts "  #{e[:title]} (#{e[:id]}) @ #{e[:venue]}" }
      end
      if matched_events.any?
        puts "\nMatched (duplicates - updated existing):"
        matched_events.each { |m| puts "  #{m[:title]} (#{m[:id]}) [#{m[:match_type]}]" }
      end
      Honeybadger.notify("MMW import succeeded: created=#{created_count}, updated=#{updated_count} from #{filename}")
    rescue => e
      Honeybadger.notify(e)
      raise e
    end
  end
end
