# lib/tasks/import_mmw_from_s3.rake
require "aws-sdk-s3"
require "json"
require "honeybadger"

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

      skip_urls = [
        "https://ra.co/events/2370518",
        "https://ra.co/events/2353591"
      ]

      events.each_with_index do |event_data, index|
        event_info = event_data["event"]
        next unless event_info

        event_url = "https://ra.co#{event_info['contentUrl']}"
        next if skip_urls.include?(event_url)

        begin
          ActiveRecord::Base.transaction do
            venue_data = event_info["venue"] || {}
            venue_name = venue_data["name"] || "Unknown Venue"
            venue_url  = venue_data["contentUrl"] ? "https://ra.co#{venue_data['contentUrl']}" : venue_data["url"]

            venue =
              if venue_url.present?
                Venue.find_or_create_by!(city_key: city, venue_url: venue_url) { |v| v.name = venue_name }
              else
                Venue.find_or_create_by!(city_key: city, name: venue_name)
              end

            genres =
              if event_info["genres"].is_a?(Array) && event_info["genres"].any?
                event_info["genres"].map { |g| Genre.find_or_create_by!(name: g["name"]) }
              else
                []
              end

            ticket_info = event_data["ticket_info"] || {}
            raw_price = ticket_info["price"]&.to_s&.split("+")&.first&.strip

            event = Event.find_or_initialize_by(city_key: city, event_url: event_url)

            attrs = {
              description: event_info["description"],
              source: "RA",
              attending_count: event_info["attending"] || 0,
              city_key: city
            }
            attrs[:title]      = event_info["title"]     unless event.manual_override_title
            attrs[:start_time] = event_info["startTime"] unless event.manual_override_times
            attrs[:end_time]   = event_info["endTime"]   unless event.manual_override_times
            attrs[:venue]      = venue                  unless event.manual_override_location

            event.assign_attributes(attrs)
            event.save!

            unless event.manual_override_ticket
              event.update!(
                ticket_tier: ticket_info["tier"],
                ticket_price: raw_price ? raw_price.gsub("$", "").to_f : 0,
                ticket_wave: ticket_info["current_tier"]
              )
            end

            event.genres = genres unless event.manual_override_genres

            if event_info["artists"]
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
