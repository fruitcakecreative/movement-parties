# lib/tasks/import_edmtrain_json.rake
require "json"
require "honeybadger"
require "set"
require_relative "../import_helpers"

namespace :import do
  desc "Import EDM Train events from local JSON file db/edmtrain.json"
  task edmtrain_json: :environment do
    tz = ImportHelpers::MMW_TZ

    # Base URLs (no query params) — Shift multi-day listings, WMC umbrella, etc.
    excluded_url_bases = [
      "https://edmtrain.com/miami-fl/shift-miami-449562",
      "https://edmtrain.com/miami-fl/shift-miami-449563",
      "https://edmtrain.com/miami-fl/shift-miami-449565",
      "https://edmtrain.com/miami-fl/winter-music-conference-wmc-481683",
      "https://edmtrain.com/miami-fl/winter-music-conference-wmc-481684",
      "https://edmtrain.com/miami-fl/winter-music-conference-wmc-481685",
      "https://edmtrain.com/miami-fl/verso-presents-universo-boat-party-chesster-483897",
      "https://edmtrain.com/miami-fl/no-sleep-miami-richard-finger-484390",
      "https://edmtrain.com/miami-fl/stereoclub-showcase-miami-satoshi-tomiie-486677",
      "https://edmtrain.com/miami-fl/one-n-only-ultra-music-festival-hotel-and-shuttle-431354",
      "https://edmtrain.com/miami-fl/essential-deep-house-brunch-scotty-boy-482724",
      "https://edmtrain.com/miami-fl/one-n-only-ultra-music-festival-hotel-and-shuttle-431355",
      "https://edmtrain.com/miami-fl/elrow-miami-474947",
      "https://edmtrain.com/miami-fl/30-hour-mmw-closing-party-on-the-terrace-483923",
      "https://edmtrain.com/miami-fl/raw-cuts-dj-tennis-483912",
      "https://edmtrain.com/miami-fl/gene-farris-shiba-san-473311",
      "https://edmtrain.com/miami-fl/hernan-cattaneo-nick-warren-484644",
      "https://edmtrain.com/miami-fl/bedrock-sunset-cruise-john-digweed-483901",
      "https://edmtrain.com/miami-fl/markem-483158",
      "https://edmtrain.com/miami-fl/cosmic-gate-luccio-460907",
      "https://edmtrain.com/miami-fl/the-soundgarden-cruise-dubfire-483902",
      "https://edmtrain.com/miami-fl/pendulum-steve-lawler-467485",
      "https://edmtrain.com/miami-fl/juany-bravo-berin-484647",
      "https://edmtrain.com/miami-fl/stefano-noferini-dimmish-480194",
      "https://edmtrain.com/miami-fl/desyn-andrey-pushkarev-484645"
    ].freeze

    normalize_artist_name = lambda do |name|
      ImportHelpers.normalize_text(name)
    end

    artist_overlap_count = lambda do |existing_event, incoming_artists|
      existing_names = existing_event.artists.map { |a| normalize_artist_name.call(a.name) }.reject(&:blank?).to_set
      incoming_names = Array(incoming_artists).map { |a| a["name"].to_s.strip }.map { |n| normalize_artist_name.call(n) }.reject(&:blank?).to_set
      (existing_names & incoming_names).size
    end

    within_two_hours = lambda do |time1, time2|
      next false if time1.blank? || time2.blank?

      t1 = time1.is_a?(Time) || time1.is_a?(ActiveSupport::TimeWithZone) ? time1 : Time.zone.parse(time1.to_s)
      t2 = time2.is_a?(Time) || time2.is_a?(ActiveSupport::TimeWithZone) ? time2 : Time.zone.parse(time2.to_s)
      ((t1 - t2).abs / 1.hour) <= 2
    rescue
      false
    end

    # When EDM Train has no startTime we parse to midnight - within_two_hours would reject
    # events at 5pm/10pm. Use same-day match instead.
    same_day = lambda do |time1, time2|
      next false if time1.blank? || time2.blank?

      t1 = time1.is_a?(Time) || time1.is_a?(ActiveSupport::TimeWithZone) ? time1 : Time.zone.parse(time1.to_s)
      t2 = time2.is_a?(Time) || time2.is_a?(ActiveSupport::TimeWithZone) ? time2 : Time.zone.parse(time2.to_s)
      t1.in_time_zone(tz).to_date == t2.in_time_zone(tz).to_date
    rescue
      false
    end

    # Date-only values must be midnight in America/New_York, not UTC — avoids "wrong day" in UI
    parse_edmtrain_date = lambda do |date_str, start_time_str|
      next nil if date_str.blank?

      date = Date.parse(date_str.to_s) rescue nil
      next nil unless date

      if start_time_str.present?
        time_part = start_time_str.to_s.strip
        if (m = time_part.match(/(\d{1,2}):(\d{2})/))
          tz.local(date.year, date.month, date.day, m[1].to_i, m[2].to_i, 0)
        else
          tz.local(date.year, date.month, date.day, 0, 0, 0)
        end
      else
        tz.local(date.year, date.month, date.day, 0, 0, 0)
      end
    rescue StandardError
      nil
    end

    infer_start_time_from_venue_day = lambda do |venue_id, local_date, city_key|
      return nil unless venue_id && local_date

      range = ImportHelpers.mmw_local_date_to_utc_range(local_date)
      others = Event.where(city_key: city_key, venue_id: venue_id)
                    .where(start_time: range)
                    .where.not(start_time: nil)
                    .order(:start_time)
                    .to_a
      return nil if others.empty?

      non_midnight = others.reject do |e|
        t = e.start_time.in_time_zone(tz)
        t.hour == 0 && t.min == 0
      end
      ref = (non_midnight.presence || others).first
      tt = ref.start_time.in_time_zone(tz)
      tz.local(local_date.year, local_date.month, local_date.day, tt.hour, tt.min, tt.sec)
    end

    skip_event = lambda do |event_data, start_time, title|
      url = event_data["link"].to_s.downcase
      text_to_check = url

      tnorm = ImportHelpers.normalize_text(title.to_s).squeeze(" ").strip.downcase
      return true if tnorm.include?("fomo express")
      return true if tnorm == ImportHelpers.normalize_text("One N Only - Ultra Music Festival Hotel & Shuttle").squeeze(" ").strip.downcase

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
        event_date = start_time.in_time_zone(tz).to_date
        next true if event_date < Date.new(2026, 3, 23)
        next true if event_date > Date.new(2026, 3, 30)
      end

      false
    end

    find_matching_event = lambda do |city:, event_url:, incoming_start_time:, incoming_title:, incoming_venue_name:, incoming_venue:, incoming_artists:, has_precise_time:, name_was_null:, headliner_name:|
      exact_match = Event.find_by_any_source_url(city, event_url)
      next [exact_match, :exact_url] if exact_match

      next [nil, nil] if incoming_start_time.blank?

      local_date = incoming_start_time.in_time_zone(tz).to_date
      day_range = ImportHelpers.mmw_local_date_to_utc_range(local_date)

      candidates = Event.includes(:venue, :artists)
                        .where(city_key: city)
                        .where(start_time: day_range)

      time_ok = has_precise_time ? within_two_hours : same_day

      next [nil, nil] if candidates.empty?

      venue_title_match = candidates.find do |event|
        next false unless ImportHelpers.edm_import_venue_matches_event?(event, resolved_venue: incoming_venue, edm_venue_name: incoming_venue_name)
        next false unless time_ok.call(event.start_time, incoming_start_time)
        ImportHelpers.edm_import_titles_equivalent?(event.title, incoming_title)
      end

      next [venue_title_match, :venue_title_match] if venue_title_match

      artist_match = candidates.find do |event|
        ImportHelpers.edm_import_venue_matches_event?(event, resolved_venue: incoming_venue, edm_venue_name: incoming_venue_name) &&
          time_ok.call(event.start_time, incoming_start_time) &&
          artist_overlap_count.call(event, incoming_artists) >= 1
      end

      next [artist_match, :artist_time_match] if artist_match

      if incoming_artists.any?
        artist_in_title_match = candidates.find do |event|
          next false unless ImportHelpers.edm_import_venue_matches_event?(event, resolved_venue: incoming_venue, edm_venue_name: incoming_venue_name)
          next false unless time_ok.call(event.start_time, incoming_start_time)
          ImportHelpers.edm_import_artist_mentioned_in_title?(event.title, incoming_artists)
        end
        next [artist_in_title_match, :artist_in_title_match] if artist_in_title_match
      end

      slug_keywords = ImportHelpers.edm_import_url_slug_keywords(event_url)
      if slug_keywords.any?
        slug_match = candidates.find do |event|
          next false unless ImportHelpers.edm_import_venue_matches_event?(event, resolved_venue: incoming_venue, edm_venue_name: incoming_venue_name)
          next false unless time_ok.call(event.start_time, incoming_start_time)
          ImportHelpers.edm_import_slug_matches_title?(slug_keywords, event.title)
        end
        next [slug_match, :url_slug_title_match] if slug_match
      end

      venue_loose_match = candidates.find do |event|
        next false unless ImportHelpers.edm_import_venue_matches_event?(event, resolved_venue: incoming_venue, edm_venue_name: incoming_venue_name)
        next false unless time_ok.call(event.start_time, incoming_start_time)
        ImportHelpers.edm_import_titles_loosely_equivalent?(event.title, incoming_title)
      end

      next [venue_loose_match, :venue_loose_title_match] if venue_loose_match

      if name_was_null && (headliner_name.present? || incoming_artists.any?)
        headliner_match = candidates.find do |event|
          next false unless ImportHelpers.edm_import_venue_matches_event?(event, resolved_venue: incoming_venue, edm_venue_name: incoming_venue_name)
          next false unless time_ok.call(event.start_time, incoming_start_time)
          (headliner_name.present? && ImportHelpers.edm_import_titles_equivalent?(event.title, headliner_name)) ||
            ImportHelpers.edm_import_artist_mentioned_in_title?(event.title, incoming_artists)
        end
        next [headliner_match, :headliner_or_artist_title_match] if headliner_match
      end

      strict_title = ImportHelpers.venue_requires_strict_title?(incoming_venue)
      if strict_title
        strict_match = candidates.find do |event|
          next false unless ImportHelpers.edm_import_venue_matches_event?(event, resolved_venue: incoming_venue, edm_venue_name: incoming_venue_name)
          next false unless time_ok.call(event.start_time, incoming_start_time)
          ImportHelpers.edm_import_titles_equivalent?(event.title, incoming_title)
        end
        next [strict_match, :strict_venue_title] if strict_match
      end

      [nil, nil]
    end

    best_age = lambda do |existing, incoming|
      next incoming if existing.blank? && incoming.present?
      existing
    end

    # Only fill blank addresses; skip mapped Clevelander venues
    fill_venue_address_if_blank = lambda do |venue_record, incoming_address, mapped_names|
      return nil unless venue_record && incoming_address.present?
      return nil if mapped_names.include?(venue_record.name)
      return nil if venue_record.address.present?

      was = venue_record.address
      now = incoming_address.to_s.strip
      venue_record.update_column(:address, now)
      { was: was.presence || "(blank)", now: now }
    end

    hr = "─" * 76

    begin
      city = "mmw"
      file_path = Rails.root.join("db", "edmtrain.json")

      unless File.exist?(file_path)
        puts "File not found: #{file_path}"
        exit
      end

      parsed = JSON.parse(File.read(file_path))
      events = case parsed
               when Array then parsed
               when Hash then parsed["events"] || parsed["data"] || parsed["results"] || []
               else []
               end
      created_count = 0
      updated_count = 0
      skipped_count = 0
      created_log_lines = []

      events.each_with_index do |event_data, index|
        begin
          ActiveRecord::Base.transaction do
            event_url = event_data["link"].to_s.strip

            base_url = Event.normalize_source_url(event_url)
            if base_url && excluded_url_bases.include?(base_url)
              skipped_count += 1
              next
            end

            raw_title = event_data["name"].to_s.strip
            artist_list = Array(event_data["artistList"] || [])
            headliner_name = artist_list.first&.dig("name").to_s.strip
            name_was_null = raw_title.blank?

            # EDM Train event name can be null - derive from artists
            title = raw_title.presence || artist_list.map { |a| a["name"].to_s.strip }.reject(&:blank?).first(3).join(", ").presence || "Unknown Event"

            venue_data = event_data["venue"] || {}
            raw_venue_name = venue_data["name"].to_s.strip.gsub(/\s+/, " ")
            raw_venue_name = "Unknown Venue" if raw_venue_name.blank?

            # Apply EDM Train -> DB venue name mapping (Clevelander, Clevelander Rooftop)
            venue_name = ImportHelpers.map_edm_train_venue_name(raw_venue_name)

            start_time = parse_edmtrain_date.call(event_data["date"], event_data["startTime"])
            end_time = nil
            if event_data["date"].present? && event_data["endTime"].present?
              d = Date.parse(event_data["date"].to_s) rescue nil
              if d && (m = event_data["endTime"].to_s.match(/(\d{1,2}):(\d{2})/))
                end_time = tz.local(d.year, d.month, d.day, m[1].to_i, m[2].to_i, 0)
              end
            end

            # South Florida (Miami–Dade, Broward / Fort Lauderdale, etc.)
            location_text = "#{venue_data["location"]} #{venue_data["address"]} #{venue_data["state"]}".to_s.downcase
            # South FL: Miami, Fort Lauderdale, Ft Lauderdale / Ft. Lauderdale, etc.
            unless location_text.match?(/miami|(?:fort|ft\.?)\s+lauderdale|lauderdale|florida|\bfl\b/)
              skipped_count += 1
              next
            end

            if event_url.blank? || title.blank? || start_time.blank?
              skipped_count += 1
              next
            end

            if skip_event.call(event_data, start_time, title)
              skipped_count += 1
              next
            end

            venue, _venue_how = ImportHelpers.find_venue_for_edm_train(
              city: city,
              mapped_venue_name: venue_name,
              raw_venue_name: raw_venue_name,
              address: venue_data["address"].to_s.strip
            )
            venue ||= Venue.create!(city_key: city, name: venue_name)

            venue = ImportHelpers.edm_train_maybe_giselle_rooftop(city: city, venue: venue, title: title)
            venue_name = venue.name

            mapped_venue_names = ImportHelpers::EDM_TRAIN_VENUE_MAP.values

            has_precise_time = event_data["startTime"].present?
            log_label = "[#{index + 1}/#{events.size}]"

            matched_event, match_type = find_matching_event.call(
              city: city,
              event_url: event_url,
              incoming_start_time: start_time,
              incoming_title: title,
              incoming_venue_name: venue_name,
              incoming_venue: venue,
              incoming_artists: artist_list,
              has_precise_time: has_precise_time,
              name_was_null: name_was_null,
              headliner_name: headliner_name
            )

            event = matched_event || Event.new(city_key: city, venue: venue)
            is_new_record = event.new_record?

            raw_age = event_data["ages"].to_s.strip
            normalized_age = raw_age.match?(/21/) ? "21+" : raw_age.match?(/18/) ? "18+" : nil
            incoming_address = venue_data["address"].to_s.strip

            if is_new_record
              start_time_note = nil
              attrs = {
                city_key: city,
                source: "EDM Train",
                edm_train_url: event_url
              }
              attrs[:event_url] = event_url if event.event_url.blank?
              attrs[:age] = best_age.call(event.age, normalized_age) if normalized_age.present?

              unless event.manual_override_title
                attrs[:title] = title
              end

              unless event.manual_override_times
                st = start_time
                if has_precise_time && st.present?
                  start_time_note = "precise (EDM startTime present)"
                elsif st.present? && !has_precise_time
                  ld = st.in_time_zone(tz).to_date
                  inferred = infer_start_time_from_venue_day.call(venue.id, ld, city)
                  st = inferred || tz.local(ld.year, ld.month, ld.day, 22, 0, 0)
                  start_time_note =
                    if inferred
                      "inferred from other events at venue that day"
                    else
                      "default 22:00 (no EDM startTime, no same-venue inference)"
                    end
                end
                attrs[:start_time] = st if st.present?
                attrs[:end_time] = end_time if end_time.present?
              end

              unless event.manual_override_location
                attrs[:venue] = venue
              end

              attrs.delete(:short_title)
              event.assign_attributes(attrs.compact)
              event.save!

              addr_change = fill_venue_address_if_blank.call(event.venue, incoming_address, mapped_venue_names)

              unless event.manual_override_artists
                artist_list.each do |artist_data|
                  name = artist_data["name"].to_s.strip
                  next if name.blank?

                  artist = Artist.find_or_create_by_canonical_name!(name)
                  event.artists << artist if artist && !event.artists.include?(artist)
                end
              end

              created_count += 1
              fmt = ->(t) { t.present? ? t.in_time_zone(tz).strftime("%a %Y-%m-%d %H:%M %Z") : "(blank)" }
              time_note = start_time_note.presence ||
                (event.manual_override_times ? "manual_override_times (start/end not set by import)" : "(no start time)")
              lines = []
              lines << "#{log_label} CREATED event id=#{event.id} title=#{event.title.inspect}"
              lines << "  edm_train_url: #{event.edm_train_url.inspect}"
              lines << "  venue: #{event.venue&.name.inspect} (venue_id=#{event.venue_id})"
              lines << "  raw_edm_venue: #{raw_venue_name.inspect} → mapped: #{ImportHelpers.map_edm_train_venue_name(raw_venue_name).inspect}"
              lines << "  start_time: #{fmt.call(event.start_time)}  (#{time_note})"
              lines << "  end_time: #{fmt.call(event.end_time)}" if event.end_time.present?
              lines << "  edm_json: date=#{event_data['date'].inspect} startTime=#{event_data['startTime'].inspect} endTime=#{event_data['endTime'].inspect}"
              lines << "  ages (edm): #{raw_age.presence || '(blank)'} → stored: #{event.age.presence || '(blank)'}"
              lines << "  address: incoming=#{incoming_address.presence || '(blank)'} | venue.address=#{event.venue&.address.presence || '(blank)'}"
              lines << "  venue.address change: #{addr_change ? "#{addr_change[:was].inspect} -> #{addr_change[:now].inspect}" : "(unchanged / not filled)"}"
              lines << "  artists: #{event.artists.reload.pluck(:name).join(', ').presence || '(none)'}"
              created_log_lines << lines.join("\n")
            else
              # Merge: only edm_train_url, age, artists, venue.address — never title
              event.edm_train_url = event_url

              if normalized_age.present?
                new_age = best_age.call(event.age, normalized_age)
                event.age = new_age if new_age != event.age
              end

              event.save! if event.changed?

              v = event.venue
              fill_venue_address_if_blank.call(v, incoming_address, mapped_venue_names)

              unless event.manual_override_artists
                artist_list.each do |artist_data|
                  name = artist_data["name"].to_s.strip
                  next if name.blank?

                  artist = Artist.find_or_create_by_canonical_name!(name)
                  event.artists << artist if artist && !event.artists.include?(artist)
                end
              end

              updated_count += 1
            end
          end
        rescue => e
          puts "Error importing EDM Train event at index #{index}: #{e.message}"
          Honeybadger.notify(e)
        end
      end

      Rails.cache.delete("events-v1:mmw") rescue nil
      Rails.cache.delete("events-v2:mmw") rescue nil

      puts "Created: #{created_count} | Updated: #{updated_count} | Skipped: #{skipped_count}"
      if created_log_lines.any?
        puts ""
        created_log_lines.each_with_index do |block, i|
          puts "\n#{hr}" if i.positive?
          puts block
        end
      end
      puts ""
    rescue => e
      Honeybadger.notify(e)
      raise e
    end
  end
end
