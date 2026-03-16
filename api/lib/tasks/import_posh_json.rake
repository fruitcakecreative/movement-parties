# lib/tasks/import_posh_json.rake
require "json"
require "honeybadger"
require "bigdecimal"
require "set"

namespace :import do
  desc 'Import Posh events from local JSON file in db/posh.json'
  task :posh_json => :environment do

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

    parse_posh_time = lambda do |value, timezone|
      next nil if value.blank?

      tz = ActiveSupport::TimeZone[timezone.presence || "America/New_York"]
      utc_time = Time.iso8601(value.to_s).utc
      local_time = utc_time.in_time_zone(tz)

      Time.zone.parse(local_time.strftime("%Y-%m-%d %H:%M:%S"))
    rescue
      nil
    end

    skip_titles = [
      "ezample",
      "Shift Miami 2026"
    ]

    skip_event = lambda do |event_data, start_time|
      next true if skip_titles.include?(event_data["name"].to_s.strip)
      title = event_data["name"].to_s.downcase
      url = event_data["url"].to_s.downcase
      group_name = event_data["groupName"].to_s.downcase

      text_to_check = "#{title} #{url} #{group_name}"

      skip_phrases = [
        "pass",
        "multi-day",
        "multi day",
        "two-day",
        "two day",
        "2-day",
        "2 day",
        "3-day",
        "3 day",
        "combo",
        "both-events",
        "both events",
        "all-access",
        "all access",
        "full week",
        "week pass",
        "festival pass"
      ]

      next true if skip_phrases.any? { |phrase| text_to_check.include?(phrase) }

      if start_time.present?
        event_date = start_time.to_date
        next true if event_date < Date.new(2026, 3, 23)
        next true if event_date > Date.new(2026, 3, 30)
      end

      false
    end

    extract_posh_price = lambda do |event_data|
      tickets = Array(event_data["tickets"])

      available_prices = tickets.filter_map do |ticket|
        next if ticket["closed"] == true
        next if ticket["disabled"] == true
        next if ticket["isHidden"] == true
        next if ticket["isAvailable"] == false

        price = ticket["totalPrice"]
        price = ticket["price"] if price.blank?

        next if price.blank?

        BigDecimal(price.to_s) rescue nil
      end

      if available_prices.any?
        available_prices.min
      else
        nil
      end
    end

    extract_posh_ticket_label = lambda do |event_data|
      price = extract_posh_price.call(event_data)
      next "FREE" if price == BigDecimal("0")
      next "$#{format('%.2f', price)}" if price.present?

      nil
    end

    find_matching_event = lambda do |city:, event_url:, incoming_title:, incoming_start_time:, incoming_venue_name:|
      exact_match =
        Event.find_by(city_key: city, event_url: event_url)

      next [exact_match, :exact_url] if exact_match

      candidates = Event.includes(:venue)
                        .where(city_key: city)
                        .where(start_time: incoming_start_time.to_date.beginning_of_day..incoming_start_time.to_date.end_of_day)

      venue_time_match = candidates.find do |event|
        venue_match.call(event.venue&.name, incoming_venue_name) &&
          within_two_hours.call(event.start_time, incoming_start_time)
      end

      if venue_time_match
        puts "VENUE/TIME MATCH: #{incoming_title} -> #{venue_time_match.title}"
        next [venue_time_match, :venue_time_match]
      end

      title_match = candidates.find do |event|
        within_two_hours.call(event.start_time, incoming_start_time) &&
          title_overlap_count.call(event.title, incoming_title) >= 2
      end

      if title_match
        puts "TITLE/TIME MATCH: #{incoming_title} -> #{title_match.title}"
        next [title_match, :title_time_match]
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
      file_path = Rails.root.join("db", "posh.json")

      unless File.exist?(file_path)
        puts "File not found: #{file_path}"
        exit
      end

      parsed = JSON.parse(File.read(file_path))
      events =
        if parsed.is_a?(Array)
          parsed
        elsif parsed.dig("result", "data", "events").is_a?(Array)
          parsed.dig("result", "data", "events")
        elsif parsed["events"].is_a?(Array)
          parsed["events"]
        else
          [parsed]
        end

      puts "Found #{events.size} Posh events in #{file_path}"

      created_count = 0
      updated_count = 0
      skipped_count = 0

      events.each_with_index do |event_data, index|
        begin
          ActiveRecord::Base.transaction do
            title = event_data["name"].to_s.strip
            event_slug = event_data["url"].to_s.strip
            group_url = event_data["groupUrl"].to_s.strip
            event_url =
              if group_url.present? && event_slug.present?
                "https://posh.vip/e/#{event_slug}"
              elsif event_slug.present?
                "https://posh.vip/e/#{event_slug}"
              else
                ""
              end

            venue_data = event_data["venue"] || {}
            venue_name = venue_data["name"].to_s.strip.gsub(/\s+/, " ")
            venue_name = "Unknown Venue" if venue_name.blank?
            venue_address = venue_data["address"].to_s.strip
            timezone = event_data["timezone"].presence || "America/New_York"

            start_time = parse_posh_time.call(event_data["startUtc"], timezone)
            end_time   = parse_posh_time.call(event_data["endUtc"], timezone)

            if event_url.blank? || title.blank? || start_time.blank?
              skipped_count += 1
              puts "Skipping #{index + 1}/#{events.size}: missing required data"
              next
            end

            if skip_event.call(event_data, start_time)
              skipped_count += 1
              puts "Skipping #{index + 1}/#{events.size}: filtered #{title}"
              next
            end

            unless venue_address.downcase.include?("miami")
              skipped_count += 1
              puts "Skipping #{index + 1}/#{events.size}: non-Miami venue #{venue_name}"
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
              incoming_venue_name: venue.name
            )

            event = matched_event || Event.new(city_key: city, venue: venue)
            is_new_record = event.new_record?
            ra_backed = event.event_url.present?

            promoter_value =
              if event.respond_to?(:promoter)
                event.promoter.presence || event_data["groupName"]
              end

            attrs = {
              city_key: city,
              source: "POSH",
              event_url: event_url
            }

            attrs[:promoter] = promoter_value if promoter_value.present?

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

            if event.respond_to?(:ticket_label)
              attrs[:ticket_label] = event.ticket_label.presence || extract_posh_ticket_label.call(event_data)
            end

            if event.respond_to?(:event_image_url) && !ra_backed
              attrs[:event_image_url] = best_image.call(event.event_image_url, event_data["flyer"])
            end

            attrs[:description] = best_description.call(event.description, nil)

            event.assign_attributes(attrs.compact)
            event.save!

            unless event.manual_override_ticket
              posh_ticket_price = extract_posh_price.call(event_data)

              update_attrs = {
                ticket_price: best_ticket_price.call(event.ticket_price, posh_ticket_price)
              }.compact

              event.update!(update_attrs) if update_attrs.present?
            end

            if is_new_record
              created_count += 1
              puts "Created #{index + 1}/#{events.size}: #{event.title}"
            else
              updated_count += 1
              puts "Updated #{index + 1}/#{events.size}: #{event.title} (#{match_type})"
            end
          end
        rescue => e
          puts "Error importing Posh event at index #{index}: #{e.message}"
          Honeybadger.notify(e)
        end
      end

      Rails.cache.delete("events-v1:mmw") rescue nil

      puts "Finished importing Posh events from #{file_path}"
      puts "Created: #{created_count}"
      puts "Updated: #{updated_count}"
      puts "Skipped: #{skipped_count}"

      Honeybadger.notify(
        "Posh import succeeded: created=#{created_count}, updated=#{updated_count}, skipped=#{skipped_count}, file=#{file_path}"
      )
    rescue => e
      Honeybadger.notify(e)
      raise e
    end
  end
end
