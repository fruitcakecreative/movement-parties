namespace :import do
  desc "Import events from latest JSON file"
  task events: :environment do
    require 'json'

    files = Dir.glob(Rails.root.join("db/events_*.json"))
    if files.empty?
      puts "No JSON files found!"
      exit
    end

    latest_file = files.max_by { |f| File.mtime(f) }
    puts "Importing from #{latest_file}"

    events = JSON.parse(File.read(latest_file))

    skip_urls = [
      "https://ra.co/events/2136172",
      "https://ra.co/events/2061680",
      "https://ra.co/events/2085466",
      "https://ra.co/events/2101035",
      "https://ra.co/events/2130939",
      "https://ra.co/events/2149596",
    ]

    events.each_with_index do |event_data, index|
      event_info = event_data["event"]
      next unless event_info

      event_url = "https://ra.co#{event_info['contentUrl']}"
      next if skip_urls.include?(event_url)

      begin
        ActiveRecord::Base.transaction do
          venue_name = event_info.dig("venue", "name") || "Unknown Venue"
          venue = Venue.find_or_create_by!(name: venue_name)

          genres = if event_info["genres"].is_a?(Array) && event_info["genres"].any?
                     event_info["genres"].map do |genre_data|
                       Genre.find_or_create_by!(name: genre_data["name"])
                     end
                   else
                     []
                   end

          ticket_info = event_data["ticket_info"] || {}
          raw_price = ticket_info["price"]&.to_s&.split("+")&.first&.strip

          event = Event.find_or_initialize_by(event_url: event_url)
          attrs = {
            description: event_info["description"],
            source: "RA",
            attending_count: event_info["attending"] || 0
          }
          attrs[:title] = event_info["title"] unless event.manual_override_title
          attrs[:start_time] = event_info["startTime"] unless event.manual_override_times
          attrs[:end_time] = event_info["endTime"] unless event.manual_override_times
          attrs[:venue] = venue unless event.manual_override_location

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
      rescue ActiveRecord::RecordInvalid => e
        puts "Error importing event at index #{index}: #{e.message}"
      end
    end

    puts "Finished importing events from #{latest_file}"
  end
end
