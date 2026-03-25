# lib/tasks/import_dice_json.rake
require "json"
require "honeybadger"
require "bigdecimal"
require "set"
require_relative "../import_helpers"

namespace :import do
  desc "Import DICE events from local JSON file"
  task :dice_json, [:file_path] => :environment do |_t, args|
    normalize_text = lambda do |value|
      value.to_s
           .downcase
           .gsub("&", " and ")
           .gsub(/[^a-z0-9\s]/, " ")
           .gsub(/\s+/, " ")
           .strip
    end

    parse_local_time = lambda do |value|
      next nil if value.blank?

      cleaned = value.to_s.sub(/([+-]\d{2}:\d{2}|Z)\z/, "")
      Time.zone.parse(cleaned)
    rescue
      nil
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

    within_two_hours = lambda do |time1, time2|
      next false if time1.blank? || time2.blank?

      t1 = time1.is_a?(Time) || time1.is_a?(ActiveSupport::TimeWithZone) ? time1 : Time.zone.parse(time1.to_s)
      t2 = time2.is_a?(Time) || time2.is_a?(ActiveSupport::TimeWithZone) ? time2 : Time.zone.parse(time2.to_s)

      ((t1 - t2).abs / 1.hour) <= 2
    rescue
      false
    end

    loose_title_overlap = lambda do |title1, title2|
      stop_words = %w[
        the a an and or of for at in on with by from to
        party event official presents presented showcase
        miami music week mmw wmc
        tickets ticket 2026
      ]

      words1 = normalize_text.call(title1).split.reject { |w| stop_words.include?(w) }.uniq
      words2 = normalize_text.call(title2).split.reject { |w| stop_words.include?(w) }.uniq

      next false if words1.empty? || words2.empty?

      (words1 & words2).any?
    end

    find_matching_event = lambda do |city:, event_url:, incoming_title:, incoming_start_time:, incoming_venue_name:, incoming_venue:, incoming_artists:|
      exact_match = Event.find_by_any_source_url(city, event_url)
      next [exact_match, :exact_url] if exact_match

      candidates = Event.includes(:venue, :artists)
                        .where(city_key: city)
                        .where(start_time: incoming_start_time.to_date.beginning_of_day..incoming_start_time.to_date.end_of_day)

      strict_title = ImportHelpers.venue_requires_strict_title?(incoming_venue)

      confirmed_match = candidates.find do |event|
        next false unless ImportHelpers.venue_match?(event.venue&.name, incoming_venue_name)
        next false unless within_two_hours.call(event.start_time, incoming_start_time)
        if strict_title
          event.title.to_s.strip.downcase == incoming_title.to_s.strip.downcase
        else
          true
        end
      end

      if confirmed_match
        puts "CONFIRMED MATCH: #{incoming_title} -> #{confirmed_match.title}"
        next [confirmed_match, :venue_time_match]
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

    safe_bigdecimal = lambda do |value|
      next nil if value.blank?

      BigDecimal(value.to_s)
    rescue ArgumentError
      nil
    end

    begin
      city = "mmw"
      file_path = args[:file_path].presence || Rails.root.join("tmp", "dice_events.json").to_s

      unless File.exist?(file_path)
        puts "File not found: #{file_path}"
        exit
      end

      events = JSON.parse(File.read(file_path))
      puts "Found #{events.size} DICE events in #{file_path}"

      created_count = 0
      updated_count = 0
      skipped_count = 0
      matched_events = []

      skip_urls = [
        "https://dice.fm/event/your-url-here",
        "https://dice.fm/event/another-url-here",
        "https://dice.fm/event/dkqbaq-where-are-my-keys-mmw-by-unmute-pickle-27th-mar-94th-aero-squadron-miami-tickets",
        "https://edmtrain.com/miami-fl/adam-collins-mazin-486825?utm_source=2360&utm_medium=api"
      ]

      events.each_with_index do |event_data, index|
        begin
          ActiveRecord::Base.transaction do
            event_url  = event_data["event_url"].to_s.strip
            title      = event_data["title"].to_s.strip
            start_time = parse_local_time.call(event_data["start_time"])
            end_time   = parse_local_time.call(event_data["end_time"])
            venue_name = event_data["venue_name"].to_s.strip.gsub(/\s+/, " ")
            venue_name = "Unknown Venue" if venue_name.blank?

            if skip_urls.include?(event_url)
              skipped_count += 1
              puts "Skipping #{index + 1}/#{events.size}: skip list match #{event_url}"
              next
            end

            if event_url.blank? || title.blank? || start_time.blank?
              skipped_count += 1
              puts "Skipping #{index + 1}/#{events.size}: missing required data"
              next
            end

            venue = ImportHelpers.find_venue(city: city, venue_name: venue_name)
            venue ||= Venue.create!(city_key: city, name: venue_name)

            matched_event, match_type = find_matching_event.call(
              city: city,
              event_url: event_url,
              incoming_title: title,
              incoming_start_time: start_time,
              incoming_venue_name: venue.name,
              incoming_venue: venue,
              incoming_artists: event_data["artists"]
            )

            event = matched_event || Event.new(city_key: city, venue: venue)
            is_new_record = event.new_record?

            attrs = {
              city_key: city,
              source: "DICE",
              promoter: event.promoter.presence || event_data["promoter"],
              age: event.age.presence || event_data["age"],
              dice_url: event_url
            }
            attrs[:event_url] = event_url if is_new_record && event.event_url.blank?

            unless event.manual_override_title
              attrs[:title] = title
            end

            unless event.manual_override_times
              if is_new_record
                attrs[:start_time] = start_time if start_time.present?
                attrs[:end_time] = end_time if end_time.present?
              end
            end

            unless event.manual_override_location
              attrs[:venue] = venue if is_new_record
            end

            attrs[:description] = best_description.call(event.description, event_data["description"])
            attrs[:event_image_url] = best_image.call(event.event_image_url, event_data["event_image_url"])

            unless event.manual_override_ticket
              attrs[:ticket_price] = best_ticket_price.call(event.ticket_price, safe_bigdecimal.call(event_data["ticket_price"]))
            end

            attrs.delete(:short_title) # never overwrite from imports
            event.assign_attributes(attrs)
            event.save!

            unless event.manual_override_artists
              incoming_artist_names = Array(event_data["artists"]).map { |name| name.to_s.strip }.reject(&:blank?).uniq

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
          puts "Error importing DICE event at index #{index}: #{e.message}"
          Honeybadger.notify(e)
        end
      end

      Rails.cache.delete("events-v1:mmw") rescue nil

      puts "Finished importing DICE events from #{file_path}"
      puts "Created: #{created_count}"
      puts "Updated: #{updated_count}"
      puts "Skipped: #{skipped_count}"
      if matched_events.any?
        puts "\nMatched (duplicates - updated existing):"
        matched_events.each { |m| puts "  #{m[:title]} (#{m[:id]}) [#{m[:match_type]}]" }
      end

      Honeybadger.notify(
        "DICE import succeeded: created=#{created_count}, updated=#{updated_count}, skipped=#{skipped_count}, file=#{file_path}"
      )
    rescue => e
      Honeybadger.notify(e)
      raise e
    end
  end
end
