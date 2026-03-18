# lib/tasks/import_shotgun_json.rake
require "json"
require "honeybadger"
require "bigdecimal"
require "set"

namespace :import do
  desc "Import Shotgun events from local JSON file"
  task shotgun_json: :environment do
    normalize_text = lambda do |value|
      value.to_s
           .downcase
           .gsub("&", " and ")
           .gsub(/[^a-z0-9\s]/, " ")
           .gsub(/\s+/, " ")
           .strip
    end

    title_words = lambda do |title|
      stop_words = %w[
        the a an and or of for at in on with by from to
        party event official presents presented
        miami music week mmw wmc
        tickets ticket 2026 records showcase
      ]

      normalize_text.call(title)
                    .split
                    .reject { |word| stop_words.include?(word) }
                    .uniq
    end

    title_overlap_count = lambda do |title1, title2|
      (title_words.call(title1) & title_words.call(title2)).size
    end

    normalize_artist_name = lambda do |name|
      normalize_text.call(name)
    end

    artist_overlap_count = lambda do |existing_event, incoming_artists|
      existing_names = existing_event.artists.map { |a| normalize_artist_name.call(a.name) }.to_set
      incoming_names = Array(incoming_artists).map { |name| normalize_artist_name.call(name) }.reject(&:blank?).to_set

      (existing_names & incoming_names).size
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

    venue_match = lambda do |existing_venue_name, incoming_venue_name|
      existing = normalize_venue_name.call(existing_venue_name)
      incoming = normalize_venue_name.call(incoming_venue_name)

      next false if existing.blank? || incoming.blank?

      existing == incoming ||
        existing.include?(incoming) ||
        incoming.include?(existing)
    end

    within_two_hours = lambda do |time1, time2|
      next false if time1.blank? || time2.blank?

      t1 = time1.is_a?(Time) || time1.is_a?(ActiveSupport::TimeWithZone) ? time1 : Time.zone.parse(time1.to_s)
      t2 = time2.is_a?(Time) || time2.is_a?(ActiveSupport::TimeWithZone) ? time2 : Time.zone.parse(time2.to_s)

      ((t1 - t2).abs / 1.hour) <= 2
    rescue
      false
    end

    parse_shotgun_time = lambda do |value|
      next nil if value.blank?

      cleaned = value.to_s.strip
      year = Time.zone.now.year
      Time.zone.strptime("#{cleaned} #{year}", "%a %d %b, %l:%M %p %Y")
    rescue
      nil
    end

    parse_shotgun_price = lambda do |value|
      next nil if value.blank?

      str = value.to_s.strip
      next BigDecimal("0") if str.casecmp("free").zero?

      cleaned = str.gsub(/[^0-9.]/, "")
      next nil if cleaned.blank?

      BigDecimal(cleaned)
    rescue ArgumentError
      nil
    end

    find_matching_event = lambda do |city:, event_url:, incoming_title:, incoming_start_time:, incoming_venue_name:, incoming_artists:|
      exact_match = Event.find_by_any_source_url(city, event_url)
      next [exact_match, :exact_url] if exact_match

      candidates = Event.includes(:venue, :artists)
                        .where(city_key: city)
                        .where(start_time: incoming_start_time.to_date.beginning_of_day..incoming_start_time.to_date.end_of_day)

      confirmed_match = candidates.find do |event|
        venue_match.call(event.venue&.name, incoming_venue_name) &&
          within_two_hours.call(event.start_time, incoming_start_time) &&
          artist_overlap_count.call(event, incoming_artists) >= 1
      end

      if confirmed_match
        puts "CONFIRMED MATCH: #{incoming_title} -> #{confirmed_match.title}"
        next [confirmed_match, :venue_time_artist_match]
      end

      artist_match = candidates.find do |event|
        within_two_hours.call(event.start_time, incoming_start_time) &&
          artist_overlap_count.call(event, incoming_artists) >= 2
      end

      if artist_match
        puts "ARTIST/TIME MATCH: #{incoming_title} -> #{artist_match.title}"
        next [artist_match, :artist_time_match]
      end

      puts "NO MATCH: #{incoming_title}"
      [nil, nil]
    end

    best_description = lambda do |existing, incoming|
      next incoming if existing.blank? && incoming.present?
      next existing if existing.present? && incoming.blank?
      next incoming if incoming.to_s.strip.length > existing.to_s.strip.length

      existing
    end

    best_image = lambda do |existing, incoming|
      next existing if incoming.blank?
      incoming
    end

    best_ticket_price = lambda do |existing, incoming|
      next incoming if existing.blank? && incoming.present?
      existing
    end

    begin
      city = "mmw"
      file_path = Rails.root.join("db", "shotgun.json")

      unless File.exist?(file_path)
        puts "File not found: #{file_path}"
        exit
      end

      events = JSON.parse(File.read(file_path))
      puts "Found #{events.size} Shotgun events in #{file_path}"

      created_count = 0
      updated_count = 0
      skipped_count = 0
      matched_events = []

      events.each_with_index do |event_data, index|
        begin
          ActiveRecord::Base.transaction do
            event_url   = event_data["eventUrl"].to_s.strip
            title       = event_data["title"].to_s.strip
            venue_name  = event_data["venue"].to_s.strip.gsub(/\s+/, " ")
            venue_name  = "Unknown Venue" if venue_name.blank?

            start_time  = parse_shotgun_time.call(event_data["startDate"])
            end_time    = parse_shotgun_time.call(event_data["endDate"])

            if start_time.present? && end_time.present? && end_time <= start_time
              end_time += 1.day
            end

            if event_url.blank? || title.blank? || start_time.blank?
              skipped_count += 1
              puts "Skipping #{index + 1}/#{events.size}: missing required data"
              next
            end

            normalized_incoming_venue = normalize_venue_name.call(venue_name)

            venue = Venue.where(city_key: city).find do |v|
              existing = normalize_venue_name.call(v.name)
              existing == normalized_incoming_venue ||
                existing.include?(normalized_incoming_venue) ||
                normalized_incoming_venue.include?(existing)
            end

            venue ||= Venue.create!(city_key: city, name: venue_name)

            matched_event, match_type = find_matching_event.call(
              city: city,
              event_url: event_url,
              incoming_title: title,
              incoming_start_time: start_time,
              incoming_venue_name: venue_name,
              incoming_artists: event_data["lineup"]
            )

            event = matched_event || Event.new(city_key: city, venue: venue)
            is_new_record = event.new_record?
            ra_backed = event.event_url.present?

            attrs = {
              city_key: city,
              source: "Shotgun",
              promoter: event.promoter.presence || event_data["organizer"],
              shotgun_url: event_url
            }
            attrs[:event_url] = event_url if is_new_record && event.event_url.blank?

            unless event.manual_override_title
              attrs[:title] = title
            end

            unless event.manual_override_times
              if is_new_record
                attrs[:start_time] = start_time if start_time.present?
                attrs[:end_time]   = end_time if end_time.present?
              end
            end

            unless event.manual_override_location
              attrs[:venue] = venue if is_new_record
            end

            attrs[:description] =
              best_description.call(event.description, event_data["description"])

            # Shotgun image can overwrite unless RA already owns image
            if !ra_backed && event_data["imageUrl"].present?
              attrs[:event_image_url] =
                best_image.call(event.event_image_url, event_data["imageUrl"])
            end

            event.assign_attributes(attrs)
            event.save!

            unless event.manual_override_ticket
              shotgun_price = parse_shotgun_price.call(event_data["price"])

              update_attrs = {
                ticket_price: best_ticket_price.call(event.ticket_price, shotgun_price)
              }.compact

              event.update!(update_attrs)
            end

            unless event.manual_override_artists
              incoming_artist_names = Array(event_data["lineup"])
                .map { |name| name.to_s.strip.gsub(/\A[[:punct:]\s]+|[[:punct:]\s]+\z/, "") }
                .reject(&:blank?)
                .uniq

              incoming_artist_names.each do |artist_name|
                artist = Artist.find_or_create_by_canonical_name!(artist_name)
                event.artists << artist if artist && !event.artists.include?(artist)
              end
            end

            if is_new_record
              created_count += 1
              puts "Created #{index + 1}/#{events.size}: #{event.title}"
            else
              updated_count += 1
              matched_events << { title: event.title, id: event.id, match_type: match_type }
              puts "Updated #{index + 1}/#{events.size}: #{event.title} (#{match_type})"
            end
          end
        rescue => e
          puts "Error importing Shotgun event at index #{index}: #{e.message}"
          Honeybadger.notify(e)
        end
      end

      Rails.cache.delete("events-v1:mmw") rescue nil

      puts "Finished importing Shotgun events"
      puts "Created: #{created_count}"
      puts "Updated: #{updated_count}"
      puts "Skipped: #{skipped_count}"
      if matched_events.any?
        puts "\nMatched (duplicates - updated existing):"
        matched_events.each { |m| puts "  #{m[:title]} (#{m[:id]}) [#{m[:match_type]}]" }
      end

      Honeybadger.notify(
        "Shotgun import succeeded: created=#{created_count}, updated=#{updated_count}, skipped=#{skipped_count}"
      )
    rescue => e
      Honeybadger.notify(e)
      raise e
    end
  end
end
