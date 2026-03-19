# lib/tasks/import_tixr_json.rake
require "json"
require "honeybadger"
require "bigdecimal"
require "set"
require_relative "../import_helpers"

namespace :import do
  desc "Import TIXR events from local JSON file in db/, e.g. rails \"import:tixr_json[502]\""
  task :tixr_json, [:source_key] => :environment do |_t, args|
    source_key = args[:source_key].to_s.strip
    if source_key.blank?
      puts 'Usage: rails "import:tixr_json[502]"'
      exit
    end

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

    within_two_hours = lambda do |time1, time2|
      next false if time1.blank? || time2.blank?

      t1 = time1.is_a?(Time) || time1.is_a?(ActiveSupport::TimeWithZone) ? time1 : Time.zone.parse(time1.to_s)
      t2 = time2.is_a?(Time) || time2.is_a?(ActiveSupport::TimeWithZone) ? time2 : Time.zone.parse(time2.to_s)

      ((t1 - t2).abs / 1.hour) <= 2
    rescue
      false
    end

    parse_tixr_local_time = lambda do |value|
      next nil if value.blank?

      cleaned = value.to_s.strip.gsub(/\s+[A-Z]{3,4}\z/, "")
      Time.zone.parse(cleaned)
    rescue
      nil
    end

    skip_event = lambda do |event_data, start_time|
      title = event_data["name"].to_s.downcase
      short_name = event_data["shortName"].to_s.downcase
      url = event_data["url"].to_s.downcase

      text_to_check = "#{title} #{short_name} #{url}"

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

    extract_tixr_price = lambda do |event_data|
      sales = Array(event_data["sales"])

      preferred_categories = %w[GA GENERAL ADMISSION]
      preferred_prices = []
      fallback_prices = []

      sales.each do |sale|
        next unless sale["state"] == "OPEN"

        category = sale["category"].to_s.upcase
        ticket_multiple = sale["ticketMultiple"].to_i
        tiers = Array(sale["tiers"])

        tiers.each do |tier|
          price = tier["minPrice"] || tier["price"]
          next if price.blank?

          decimal_price = BigDecimal(price.to_s) rescue nil
          next if decimal_price.nil?

          fallback_prices << decimal_price

          if preferred_categories.include?(category) && ticket_multiple <= 1
            preferred_prices << decimal_price
          end
        end
      end

      if preferred_prices.any?
        preferred_prices.min
      elsif fallback_prices.any?
        fallback_prices.min
      else
        sale_label = event_data["saleLabel"].to_s.strip.downcase
        sale_label.start_with?("free") ? BigDecimal("0") : nil
      end
    end

    normalize_artist_name = lambda do |name|
      normalize_text.call(name)
    end

    artist_overlap_count = lambda do |existing_event, incoming_artists|
      existing_names = existing_event.artists.map { |a| normalize_artist_name.call(a.name) }.reject(&:blank?).to_set
      incoming_names = Array(incoming_artists).map { |name| normalize_artist_name.call(name) }.reject(&:blank?).to_set

      (existing_names & incoming_names).size
    end

    find_matching_event = lambda do |city:, event_url:, incoming_title:, incoming_start_time:, incoming_venue_name:, incoming_venue:, incoming_artists:, source_key:|
      exact_match = Event.find_by_any_source_url(city, event_url)
      next [exact_match, :exact_url] if exact_match

      candidates = Event.includes(:venue, :artists)
                        .where(city_key: city)
                        .where(start_time: incoming_start_time.to_date.beginning_of_day..incoming_start_time.to_date.end_of_day)

      strict_title = ImportHelpers.venue_requires_strict_title?(incoming_venue)

      confirmed_match = candidates.find do |event|
        next false unless ImportHelpers.venue_match?(event.venue&.name, incoming_venue_name)
        next false unless within_two_hours.call(event.start_time, incoming_start_time)
        next false unless artist_overlap_count.call(event, incoming_artists) >= 1
        if strict_title
          event.title.to_s.strip.downcase == incoming_title.to_s.strip.downcase
        else
          true
        end
      end

      if confirmed_match
        puts "CONFIRMED MATCH: #{incoming_title} -> #{confirmed_match.title}"
        next [confirmed_match, :venue_time_artist_match]
      end

      if source_key != "1878"
        venue_time_match = candidates.find do |event|
          next false unless ImportHelpers.venue_match?(event.venue&.name, incoming_venue_name)
          next false unless within_two_hours.call(event.start_time, incoming_start_time)
          if strict_title
            event.title.to_s.strip.downcase == incoming_title.to_s.strip.downcase
          else
            true
          end
        end

        if venue_time_match
          puts "VENUE/TIME MATCH: #{incoming_title} -> #{venue_time_match.title}"
          next [venue_time_match, :venue_time_match]
        end
      end

      if source_key == "1878" || strict_title
        exact_title_time_match = candidates.find do |event|
          within_two_hours.call(event.start_time, incoming_start_time) &&
            event.title.to_s.strip.downcase == incoming_title.to_s.strip.downcase &&
            ImportHelpers.venue_match?(event.venue&.name, incoming_venue_name)
        end

        if exact_title_time_match
          puts "EXACT TITLE/TIME MATCH: #{incoming_title} -> #{exact_title_time_match.title}"
          next [exact_title_time_match, :exact_title_time_match]
        end
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
      file_path = Rails.root.join("db", "#{source_key}-tixr.json")

      unless File.exist?(file_path)
        puts "File not found: #{file_path}"
        exit
      end

      events = JSON.parse(File.read(file_path))
      puts "Found #{events.size} TIXR events in #{file_path}"

      created_count = 0
      updated_count = 0
      skipped_count = 0
      matched_events = []

      events.each_with_index do |event_data, index|
        begin
          ActiveRecord::Base.transaction do
            unless event_data["status"] == "PUBLISHED"
              skipped_count += 1
              puts "Skipping #{index + 1}/#{events.size}: status #{event_data["status"]}"
              next
            end

            venue_data = event_data["venue"] || {}
            address_data = venue_data["address"] || {}

            venue_city = address_data["city"].to_s.strip
            allowed_cities = ["miami", "miami beach"]

            unless allowed_cities.include?(venue_city.downcase)
              skipped_count += 1
              puts "Skipping #{index + 1}/#{events.size}: non-Miami city #{venue_city}"
              next
            end

            event_url   = event_data["url"].to_s.strip
            title       = event_data["name"].to_s.strip
            venue_name  = venue_data["name"].to_s.strip.gsub(/\s+/, " ")
            venue_name  = "Unknown Venue" if venue_name.blank?

            start_time = parse_tixr_local_time.call(event_data["formattedStartDate"])
            end_time   = parse_tixr_local_time.call(event_data["formattedEndDate"])

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

            venue = ImportHelpers.find_venue(city: city, venue_name: venue_name)
            venue ||= Venue.create!(city_key: city, name: venue_name)

            if source_key == "1878"
              if title.downcase.include?("rooftop")
                venue = Venue.find_or_create_by!(city_key: city, name: "C-Level Rooftop Terrace")
              else
                venue = Venue.find_or_create_by!(city_key: city, name: "Clevelander South Beach")
              end
            end

            matched_event, match_type = find_matching_event.call(
              city: city,
              event_url: event_url,
              incoming_title: title,
              incoming_start_time: start_time,
              incoming_venue_name: venue.name,
              incoming_venue: venue,
              incoming_artists: [],
              source_key: source_key
            )

            event = matched_event || Event.new(city_key: city, venue: venue)
            is_new_record = event.new_record?
            ra_backed = event.event_url.present?

            raw_age = event.age.presence || event_data["ageRestriction"]

            normalized_age =
              if raw_age.to_s.match?(/21/)
                "21+"
              elsif raw_age.to_s.match?(/18/)
                "18+"
              else
                nil
              end

            promoter_value =
              if event.respond_to?(:promoter)
                event.promoter.presence || "TIXR #{source_key}"
              end

            attrs = {
              city_key: city,
              source: "TIXR",
              tixr_url: event_url
            }
            attrs[:event_url] = event_url if is_new_record && event.event_url.blank?

            attrs[:promoter] = promoter_value if promoter_value.present?
            attrs[:age] = normalized_age if normalized_age.present?

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
              attrs[:ticket_label] = event.ticket_label.presence || event_data["saleLabel"]
            end

            if event.respond_to?(:event_image_url)
              if !ra_backed && event_data["flyerUrl"].present?
                attrs[:event_image_url] = best_image.call(event.event_image_url, event_data["flyerUrl"])
              elsif !ra_backed && event_data["mobileImageUrl"].present?
                attrs[:event_image_url] = best_image.call(event.event_image_url, event_data["mobileImageUrl"])
              end
            end

            attrs[:description] = best_description.call(event.description, nil)

            attrs.delete(:short_title) # never overwrite from imports
            event.assign_attributes(attrs.compact)
            event.save!

            unless event.manual_override_ticket
              tixr_ticket_price = extract_tixr_price.call(event_data)

              update_attrs = {
                ticket_price: best_ticket_price.call(event.ticket_price, tixr_ticket_price)
              }.compact

              event.update!(update_attrs) if update_attrs.present?
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
          puts "Error importing TIXR event at index #{index}: #{e.message}"
          Honeybadger.notify(e)
        end
      end

      Rails.cache.delete("events-v1:mmw") rescue nil

      puts "Finished importing TIXR events from #{file_path}"
      puts "Created: #{created_count}"
      puts "Updated: #{updated_count}"
      puts "Skipped: #{skipped_count}"
      if matched_events.any?
        puts "\nMatched (duplicates - updated existing):"
        matched_events.each { |m| puts "  #{m[:title]} (#{m[:id]}) [#{m[:match_type]}]" }
      end

      Honeybadger.notify(
        "TIXR import succeeded: created=#{created_count}, updated=#{updated_count}, skipped=#{skipped_count}, file=#{file_path}"
      )
    rescue => e
      Honeybadger.notify(e)
      raise e
    end
  end
end
