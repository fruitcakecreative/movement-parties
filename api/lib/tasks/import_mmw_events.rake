# lib/tasks/import_mmw_from_s3.rake
require "aws-sdk-s3"
require "json"
require "honeybadger"
require "bigdecimal"

namespace :import do
  desc "Import MMW events from latest S3 JSON file"
  task mmw_from_s3: :environment do
    begin
      city   = "mmw"
      bucket = "mmw-parties-events-data"
      prefix = "events/"

      normalize_text = lambda do |value|
        value.to_s
             .downcase
             .gsub("&", " and ")
             .gsub(/[^a-z0-9\s]/, " ")
             .gsub(/\s+/, " ")
             .strip
      end

      normalize_venue_name = lambda do |name|
        normalize_text.call(name)
                      .gsub(/\bthe\b/, "")
                      .gsub(/\bclub\b/, "")
                      .gsub(/\bmiami\b/, "")
                      .gsub(/\bsound\b/, "")
                      .gsub(/\broom\b/, "")
                      .gsub(/\s+/, " ")
                      .strip
      end

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
      ]

      events.each_with_index do |event_data, index|
        event_info = event_data["event"]
        next unless event_info

        event_url = "https://ra.co#{event_info['contentUrl']}"
        next if skip_urls.include?(event_url)

        begin
          ActiveRecord::Base.transaction do
            venue_name = (event_info.dig("venue", "name") || "Unknown Venue")
                          .to_s.strip.gsub(/\s+/, " ")

            normalized_incoming_venue = normalize_venue_name.call(venue_name)

            venue = Venue.where(city_key: city).find do |v|
              existing = normalize_venue_name.call(v.name)
              existing == normalized_incoming_venue ||
                existing.include?(normalized_incoming_venue) ||
                normalized_incoming_venue.include?(existing)
            end

            venue ||= Venue.create!(city_key: city, name: venue_name)

            genres =
              if event_info["genres"].is_a?(Array) && event_info["genres"].any?
                event_info["genres"].map { |g| Genre.find_or_create_by!(name: g["name"]) }
              else
                []
              end

            event = Event.find_or_initialize_by(city_key: city, event_url: event_url)
            dice_backed = event.dice_url.present?

            images = event_info["images"] || []
            flyer_front = images.find { |img| img["type"] == "FLYERFRONT" }
            event_image_url = flyer_front&.dig("filename") || images.first&.dig("filename")

            attrs = {
              source: "RA",
              attending_count: event_info["attending"] || 0,
              city_key: city
            }

            attrs[:title] = event_info["title"] unless event.manual_override_title
            attrs[:start_time] = event_info["startTime"] unless event.manual_override_times
            attrs[:end_time] = event_info["endTime"] unless event.manual_override_times
            attrs[:venue] = venue unless event.manual_override_location

            # Only let RA own image if the event is not DICE-backed
            if !dice_backed && event_image_url.present?
              attrs[:event_image_url] = event_image_url
            end

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
                artist = Artist.find_or_create_by!(name: artist_data["name"])
                event.artists << artist unless event.artists.include?(artist)
              end
            end
          end
        rescue => e
          puts "Error importing event at index #{index}: #{e.message}"
          Honeybadger.notify(e)
        end
      end

      Rails.cache.delete("events-v1:mmw") rescue nil
      puts "Finished importing #{events.size} events from #{filename}"
      Honeybadger.notify("MMW import succeeded: #{events.size} events from #{filename}")
    rescue => e
      Honeybadger.notify(e)
      raise e
    end
  end
end
