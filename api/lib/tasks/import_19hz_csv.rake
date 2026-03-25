# frozen_string_literal: true

# import:nineteen_hz_csv — ENV reference
# -----------------------------------------------------------------------------
# Source (default: hosted Miami CSV — do not set CSV_FILE):
#   CSV_URL     Optional. Default: https://19hz.info/events_Miami.csv
#   CSV_FILE    If set, read this path instead of fetching CSV_URL (local dev only).
#
# Row date filter (CSV "day" column must fall in this inclusive range):
#   IMPORT_START   YYYY-MM-DD
#   IMPORT_END     YYYY-MM-DD
#   Set both for a custom range. If either is unset, each falls back to the default window (Mar 24 / Mar 30 in YEAR).
#   YEAR           Used for those defaults and for parsing the CSV year in column 0 (default: current year).
#
# Other:
#   CITY=mmw  DRY_RUN=1  VERBOSE=1  EVENTBRITE_ONLY=0 (import non-Eventbrite ticket URLs too)
# -----------------------------------------------------------------------------

require "csv"
require "open-uri"
require "set"
require_relative "../import_helpers"

namespace :import do
  # Skip rows whose ticket links point here (normalized, no query string).
  NINETEEN_HZ_IGNORED_URL_BASES = [
    "https://posh.vip/e/shift-miami-2026",
    "https://feverup.com/m/500105"
  ].freeze

  desc(<<~DESC.gsub(/\s+/, " ").strip)
    Import 19hz CSV: hosted CSV by default (CSV_URL or https://19hz.info/events_Miami.csv).
    Set CSV_FILE=path to use a local file instead. Row dates: IMPORT_START & IMPORT_END (YYYY-MM-DD),
    else YEAR with default Mar 24–30. Eventbrite-only unless EVENTBRITE_ONLY=0. See file header for ENV list.
  DESC
  task nineteen_hz_csv: :environment do
    # CSV date/time columns are already local Eastern (America/New_York) wall time — no UTC shift.
    # (March MMW is typically EDT; we use this zone so DST is correct.)
    tz = ImportHelpers::MMW_TZ
    csv_url = ENV["CSV_URL"].presence || "https://19hz.info/events_Miami.csv"
    local_path = ENV["CSV_FILE"].presence
    year = (ENV["YEAR"].presence || Time.current.year).to_i
    city = ENV["CITY"].presence || "mmw"
    dry_run = ENV["DRY_RUN"] == "1"
    verbose = ENV["VERBOSE"] == "1"

    # Default MMW window; override with IMPORT_START / IMPORT_END (YYYY-MM-DD).
    import_range_start = ENV["IMPORT_START"].present? ? Date.parse(ENV["IMPORT_START"]) : Date.new(year, 3, 24)
    import_range_end = ENV["IMPORT_END"].present? ? Date.parse(ENV["IMPORT_END"]) : Date.new(year, 3, 30)

    within_hours = lambda do |time1, time2, max_hours|
      next false if time1.blank? || time2.blank? || max_hours.blank?

      t1 = time1.is_a?(Time) || time1.is_a?(ActiveSupport::TimeWithZone) ? time1 : tz.parse(time1.to_s)
      t2 = time2.is_a?(Time) || time2.is_a?(ActiveSupport::TimeWithZone) ? time2 : tz.parse(time2.to_s)
      ((t1 - t2).abs / 1.hour) <= max_hours
    rescue StandardError
      false
    end

    # Interpret "11pm" / "3am" as Eastern wall time on local_date (same as CSV).
    parse_clock_on_date = lambda do |clock_str, local_date|
      s = clock_str.to_s.strip
      m = s.match(/\A(\d{1,2})(?::(\d{2}))?\s*(am|pm)\z/i)
      return nil unless m

      h = m[1].to_i
      min = (m[2] || "0").to_i
      mer = m[3].downcase
      if mer == "pm" && h != 12
        h += 12
      elsif mer == "am" && h == 12
        h = 0
      end
      tz.local(local_date.year, local_date.month, local_date.day, h, min, 0)
    end

    # "11pm-5am" or "6pm-3am" → start time on local_date
    start_time_from_range = lambda do |range_str, local_date|
      first = range_str.to_s.split(/[-–—]/).first&.strip
      parse_clock_on_date.call(first, local_date)
    end

    parse_row_date = lambda do |row|
      ds = row[0].to_s.strip
      Date.strptime("#{ds} #{year}", "%a: %b %d %Y")
    rescue ArgumentError
      serial = row[10].to_s.to_f
      raise if serial < 40_000

      Date.new(1899, 12, 30) + serial.floor
    end

    strip_venue_name = lambda do |raw|
      raw.to_s.gsub(/\s*\([^)]*\)\s*\z/, "").strip.gsub(/\s+/, " ")
    end

    # Venue column looks like "Do Not Sit On The Furniture (Miami Beach)" — only these parenthetical cities.
    paren_city_canonical = lambda do |venue_col|
      m = venue_col.to_s.match(/\(([^)]+)\)\s*\z/)
      return nil unless m

      inner = m[1].strip.sub(/,\s*fl(orida)?\s*$/i, "").strip.downcase.gsub(/\s+/, " ")
      inner = inner.gsub(/\bft\.?\s*/i, "fort ").gsub(/\s+/, " ").strip

      case inner
      when "miami beach" then "miami beach"
      when "miami" then "miami"
      when "fort lauderdale" then "fort lauderdale"
      else
        nil
      end
    end

    route_url_to_columns = lambda do |url|
      return {} if url.blank?

      u = url.to_s.strip
      h = {}
      if u.include?("dice.fm")
        h[:dice_url] = u
      elsif u.include?("ra.co")
        h[:ra_url] = u
      elsif u.include?("shotgun.live")
        h[:shotgun_url] = u
      elsif u.include?("posh.vip")
        h[:posh_url] = u
      elsif u.include?("tixr.com")
        h[:tixr_url] = u
      elsif u.include?("edmtrain.com")
        h[:edm_train_url] = u
      else
        h[:event_url] = u
      end
      h
    end

    merge_url_attrs = lambda do |url_a, url_b|
      out = {}
      [url_a, url_b].compact.each do |u|
        route_url_to_columns.call(u).each do |k, v|
          out[k] ||= v
        end
      end
      out
    end

    # Dice / RA are covered by dedicated importers — skip 19hz rows that only point there.
    dice_or_ra_url = lambda do |url|
      u = url.to_s.downcase
      u.include?("dice.fm") || u.include?("ra.co")
    end

    ignored_ticket_url = lambda do |url|
      return false if url.blank?

      needle = Event.normalize_source_url(url.to_s.strip)
      NINETEEN_HZ_IGNORED_URL_BASES.any? { |base| needle == base || needle.start_with?("#{base}/") }
    end

    # At least one ticket URL must be Eventbrite (short links like evb.me resolve to eventbrite.com when opened).
    eventbrite_ticket_url = lambda do |url|
      return false if url.blank?

      u = url.to_s.strip
      return true if u.match?(%r{\beventbrite\.(com|co\.[a-z]{2})/}i)
      return true if u.include?("evb.me/")

      host = URI.parse(u).host.to_s.downcase
      host.include?("eventbrite") || host.include?("evb.me")
    rescue URI::InvalidURIError, ArgumentError
      u.downcase.include?("eventbrite.com") || u.downcase.include?("evb.me")
    end

    # Dedup: exact URL first, then same-day events at the same venue with a *title* match (19hz titles differ
    # from Dice/RA). Prefer venue_id when the venue row exists. Widen time window in steps and pick closest time.
    find_matching_event = lambda do |incoming_title:, incoming_start_time:, incoming_venue_name:, incoming_venue:, url_a:, url_b:|
      exact = [url_a, url_b].compact.map { |u| Event.find_by_any_source_url(city, u) }.compact.first
      next [exact, :exact_url] if exact
      next [nil, nil] if incoming_start_time.blank?

      local_date = incoming_start_time.in_time_zone(tz).to_date
      day_range = ImportHelpers.mmw_local_date_to_utc_range(local_date)
      candidates = Event.includes(:venue, :artists)
                        .where(city_key: city)
                        .where(start_time: day_range)

      strict_venue = ImportHelpers.venue_requires_strict_title?(incoming_venue)

      venue_resolved = lambda do |event|
        ImportHelpers.edm_import_venue_matches_event?(event, resolved_venue: incoming_venue, edm_venue_name: incoming_venue_name)
      end

      title_exact_ci = lambda do |event|
        event.title.to_s.strip.casecmp?(incoming_title.to_s.strip)
      end

      title_same_show = lambda do |event|
        ImportHelpers.edm_import_titles_equivalent?(event.title, incoming_title) ||
          ImportHelpers.edm_import_titles_loosely_equivalent?(event.title, incoming_title) ||
          ImportHelpers.title_words_match?(incoming_title, event.title)
      end

      pick_closest = lambda do |pool|
        pool.min_by { |e| (e.start_time - incoming_start_time).abs }
      end

      time_ok_or_placeholder = lambda do |event, max_hours|
        next true if ImportHelpers.event_start_time_is_local_midnight_placeholder?(event, tz)

        within_hours.call(event.start_time, incoming_start_time, max_hours)
      end

      if strict_venue
        pool = candidates.select do |e|
          venue_resolved.call(e) &&
            time_ok_or_placeholder.call(e, 2) &&
            title_exact_ci.call(e)
        end
        best = pick_closest.call(pool) if pool.any?
        if best
          puts "VENUE/STRICT TITLE: #{incoming_title} -> #{best.title}" if ENV["VERBOSE"] == "1"
          next [best, :venue_strict_title]
        end
        puts "NO MATCH (strict venue): #{incoming_title}" if ENV["VERBOSE"] == "1"
        next [nil, nil]
      end

      matched = nil
      matched_type = nil
      [4, 12, 24].each do |max_h|
        pool = candidates.select do |e|
          venue_resolved.call(e) &&
            time_ok_or_placeholder.call(e, max_h) &&
            title_same_show.call(e)
        end
        next if pool.empty?

        matched = pick_closest.call(pool)
        matched_type = :"venue_title_#{max_h}h"
        puts "VENUE/TITLE (~#{max_h}h): #{incoming_title} -> #{matched.title}" if ENV["VERBOSE"] == "1"
        break
      end
      next [matched, matched_type] if matched

      puts "NO MATCH: #{incoming_title}" if ENV["VERBOSE"] == "1"
      [nil, nil]
    end

    best_age = lambda do |existing, incoming|
      next incoming if existing.blank? && incoming.present?
      existing
    end

    normalize_age = lambda do |raw|
      s = raw.to_s.strip
      return "21+" if s.match?(/21/)
      return "18+" if s.match?(/18/)

      s.presence
    end

    hr = "─" * 76
    created_log_lines = []

    raw = if local_path
            path = File.expand_path(local_path)
            raise "File not found: #{path}" unless File.exist?(path)

            File.binread(path)
          else
            URI.open(csv_url, "User-Agent" => "movement-parties-import/1.0", read_timeout: 60).read
          end

    utf = raw.force_encoding("Windows-1252").encode("UTF-8", invalid: :replace, undef: :replace)
    rows = CSV.parse(utf)

    eb_only = ENV["EVENTBRITE_ONLY"] != "0"

    source_line =
      if local_path
        path = File.expand_path(local_path)
        "  Source: local file #{path}  (unset CSV_FILE to fetch hosted CSV instead)"
      else
        "  Source: hosted #{csv_url}"
      end

    puts <<~BANNER
      19hz CSV import
      #{source_line}
        Row date filter: #{import_range_start} .. #{import_range_end}  (IMPORT_START / IMPORT_END=YYYY-MM-DD; or YEAR=#{year} for default Mar 24–30)
        Venue: (…) Miami Beach / Miami / Fort Lauderdale · skip Dice/RA ·#{eb_only ? ' Eventbrite ticket URLs only (EVENTBRITE_ONLY=0 to allow all)' : ' all ticket URLs'}
    BANNER

    created_count = 0
    updated_count = 0
    skipped_count = 0
    dry_would_create = 0
    dry_would_update = 0

    rows.each_with_index do |row, index|
      # Expect 11 columns; tolerate short rows
      next if row.blank?

      begin
        ActiveRecord::Base.transaction do
          title = row[1].to_s.strip
          venue_raw = row[3].to_s.strip
          time_range = row[4].to_s.strip
          price_str = row[5].to_s.strip
          genres_raw = row[2].to_s.strip
          artists_raw = row[7].to_s.strip
          url_primary = row[8].to_s.strip.presence
          url_secondary = row[9].to_s.strip.presence

          if title.blank?

            skipped_count += 1
            next
          end

          unless paren_city_canonical.call(venue_raw)
            skipped_count += 1
            next
          end

          local_date = parse_row_date.call(row)
          unless local_date >= import_range_start && local_date <= import_range_end
            skipped_count += 1
            next
          end

          start_time = start_time_from_range.call(time_range, local_date)
          if start_time.blank?
            start_time = tz.local(local_date.year, local_date.month, local_date.day, 22, 0, 0)
          end

          unless url_primary.present? || url_secondary.present?
            skipped_count += 1
            next
          end

          if dice_or_ra_url.call(url_primary) || dice_or_ra_url.call(url_secondary)
            skipped_count += 1
            next
          end

          if ignored_ticket_url.call(url_primary) || ignored_ticket_url.call(url_secondary)
            skipped_count += 1
            next
          end

          if eb_only && !eventbrite_ticket_url.call(url_primary) && !eventbrite_ticket_url.call(url_secondary)
            skipped_count += 1
            next
          end

          venue_name = strip_venue_name.call(venue_raw)
          venue_name = "Unknown Venue" if venue_name.blank?

          venue = ImportHelpers.find_venue(city: city, venue_name: venue_name)
          if venue.nil?
            venue =
              if dry_run
                Venue.new(city_key: city, name: venue_name)
              else
                Venue.create!(city_key: city, name: venue_name)
              end
          end

          matched_event, = find_matching_event.call(
            incoming_title: title,
            incoming_start_time: start_time,
            incoming_venue_name: venue.name,
            incoming_venue: venue,
            url_a: url_primary,
            url_b: url_secondary
          )

          event = matched_event || Event.new(city_key: city, venue: venue)
          is_new_record = event.new_record?

          url_attrs = merge_url_attrs.call(url_primary, url_secondary)
          if url_attrs[:event_url].blank? && url_primary.present? && route_url_to_columns.call(url_primary).empty?
            url_attrs[:event_url] = url_primary
          end

          notes_bits = ["19hz #{time_range}".strip]
          notes_bits << price_str if price_str.present?
          incoming_notes = notes_bits.join(" · ")

          if url_attrs.empty?
            skipped_count += 1
            next
          end

          if dry_run
            if is_new_record
              dry_would_create += 1
            else
              dry_would_update += 1
            end
            if verbose
              action = is_new_record ? "CREATE" : "UPDATE"
              puts "[dry_run #{action}] #{title} @ #{venue.name} #{start_time.iso8601}"
            end
            next
          end

          if is_new_record
            attrs = {
              city_key: city,
              source: "19hz",
              title: title,
              start_time: start_time,
              venue: venue,
              notes: incoming_notes,
              age: normalize_age.call(row[6]),
              free_event: price_str.match?(/\bfree\b/i)
            }.merge(url_attrs)

            attrs[:event_url] = url_primary if attrs[:event_url].blank? && url_primary.present?

            attrs.delete(:short_title)
            event.assign_attributes(attrs.compact)
            event.save!

            unless event.manual_override_genres
              genres_raw.split(",").map(&:strip).reject(&:blank?).each do |gname|
                g = Genre.find_or_create_by_canonical_name!(gname)
                event.genres << g unless event.genres.include?(g)
              end
            end

            unless event.manual_override_artists
              artists_raw.split(",").map(&:strip).reject(&:blank?).each do |aname|
                artist = Artist.find_or_create_by_canonical_name!(aname)
                event.artists << artist if artist && !event.artists.include?(artist)
              end
            end

            created_count += 1
            log = [
              "[#{index + 1}/#{rows.size}] CREATED id=#{event.id} #{title.inspect}",
              "  venue: #{venue.name.inspect} start: #{start_time.inspect}",
              "  urls: #{url_attrs.inspect}"
            ].join("\n")
            created_log_lines << log
          else
            event.assign_attributes(url_attrs.compact)
            if event.respond_to?(:notes) && event.notes.present?
              event.notes = "#{event.notes}\n#{incoming_notes}" unless event.notes.include?(incoming_notes[0..20].to_s)
            elsif event.respond_to?(:notes)
              event.notes = incoming_notes
            end
            na = normalize_age.call(row[6])
            event.age = best_age.call(event.age, na) if na.present?

            event.save! if event.changed?

            unless event.manual_override_genres
              genres_raw.split(",").map(&:strip).reject(&:blank?).each do |gname|
                g = Genre.find_or_create_by_canonical_name!(gname)
                event.genres << g unless event.genres.include?(g)
              end
            end

            unless event.manual_override_artists
              artists_raw.split(",").map(&:strip).reject(&:blank?).each do |aname|
                artist = Artist.find_or_create_by_canonical_name!(aname)
                event.artists << artist if artist && !event.artists.include?(artist)
              end
            end

            updated_count += 1
          end
        end
      rescue StandardError => e
        puts "Error row #{index + 1}: #{e.message}"
        raise
      end
    end

    unless dry_run
      %w[movement mmw].each { |ck| Rails.cache.delete("events-v1:#{ck}") rescue nil }
      %w[movement mmw].each { |ck| Rails.cache.delete("events-v2:#{ck}") rescue nil }
    end

    if dry_run
      puts "Dry run — no database changes. Would create: #{dry_would_create} | Would update: #{dry_would_update} | Skipped: #{skipped_count}"
      puts "(Set VERBOSE=1 with DRY_RUN=1 to print each row.)" unless verbose
    else
      puts "Created: #{created_count} | Updated: #{updated_count} | Skipped: #{skipped_count}"
    end
    if created_log_lines.any?
      puts ""
      created_log_lines.each_with_index do |block, i|
        puts "\n#{hr}" if i.positive?
        puts block
      end
    end
    puts ""
  end
end
