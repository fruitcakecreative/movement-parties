# frozen_string_literal: true

require "csv"

# Round-trip for CSVs from export:movement_* tasks. Updates existing rows by id only (no creates).
# Use api/data/exports/ (git-tracked) — not api/tmp/ (gitignored).
#
#   FILE=api/data/exports/movement_venues.csv  bin/rails import:movement_venues_csv
#   FILE=api/data/exports/movement_events.csv   bin/rails import:movement_events_csv
#   FILE=api/data/exports/movement_artists.csv bin/rails import:movement_artists_csv
#
# Preview: DRY_RUN=1 FILE=api/data/exports/movement_artists.csv bin/rails import:movement_artists_csv
#
# Full DB restore from pg_dump / S3 is separate — use pg_restore or psql.

namespace :import do
  desc "Update Movement venues from CSV (same columns as export:movement_venues). FILE= required. DRY_RUN=1 to preview."
  task movement_venues_csv: :environment do
    path = ENV["FILE"].to_s.strip.presence
    raise "Set FILE=path/to/venues.csv" if path.blank?

    dry = ENV["DRY_RUN"].to_s == "1"
    expected = %w[id name location venue_type serves_alcohol venue_url address description age]

    updated = 0
    skipped = 0

    CSV.open(path, "r:BOM|UTF-8", headers: true, header_converters: :downcase) do |csv|
      missing = expected - csv.headers.map(&:to_s)
      raise "CSV missing columns: #{missing.join(', ')}" if missing.any?

      csv.each do |row|
        id = row["id"].to_s.strip
        next if id.blank?

        venue = Venue.find_by(id: id, city_key: "movement")
        unless venue
          warn "Skip: no Movement venue id=#{id}"
          skipped += 1
          next
        end

        attrs = {
          name: row["name"].presence,
          location: row["location"].presence,
          venue_type: row["venue_type"].presence,
          serves_alcohol: row["serves_alcohol"].presence,
          venue_url: row["venue_url"].presence,
          address: row["address"].presence,
          description: row["description"].presence,
          age: row["age"].presence
        }

        if dry
          puts "[DRY] would update venue #{id}: #{attrs.inspect}"
        else
          venue.update!(attrs)
        end
        updated += 1
      end
    end

    puts dry ? "DRY_RUN: would touch #{updated} venues (#{skipped} skipped)." : "Updated #{updated} venues (#{skipped} skipped)."
  end

  desc "Update Movement events from CSV (same columns as export:movement_events). FILE= required. DRY_RUN=1 to preview."
  task movement_events_csv: :environment do
    path = ENV["FILE"].to_s.strip.presence
    raise "Set FILE=path/to/events.csv" if path.blank?

    dry = ENV["DRY_RUN"].to_s == "1"
    expected = %w[id title venue description age]

    updated = 0
    skipped = 0

    CSV.open(path, "r:BOM|UTF-8", headers: true, header_converters: :downcase) do |csv|
      missing = expected - csv.headers.map(&:to_s)
      raise "CSV missing columns: #{missing.join(', ')}" if missing.any?

      csv.each do |row|
        id = row["id"].to_s.strip
        next if id.blank?

        event = Event.find_by(id: id, city_key: "movement")
        unless event
          warn "Skip: no Movement event id=#{id}"
          skipped += 1
          next
        end

        venue_name = row["venue"].to_s.strip
        venue_id = event.venue_id
        if venue_name.present?
          v =
            Venue.where(city_key: "movement").where(
              "LOWER(TRIM(name)) = ?",
              venue_name.downcase
            ).first
          if v
            venue_id = v.id
          else
            warn "Venue not found for event #{id} (keeping venue_id=#{event.venue_id}): #{venue_name.inspect}"
          end
        end

        attrs = {
          title: row["title"].presence,
          description: row["description"].presence,
          age: row["age"].presence,
          venue_id: venue_id
        }

        if dry
          puts "[DRY] would update event #{id}: #{attrs.inspect}"
        else
          event.update!(attrs)
        end
        updated += 1
      end
    end

    Event.clear_public_index_cache!("movement") if !dry && updated.positive?

    puts dry ? "DRY_RUN: would touch #{updated} events (#{skipped} skipped)." : "Updated #{updated} events (#{skipped} skipped)."
  end

  desc "Update artists from CSV (same columns as export:movement_artists). Only ids tied to Movement events. FILE= required. DRY_RUN=1 to preview."
  task movement_artists_csv: :environment do
    path = ENV["FILE"].to_s.strip.presence
    raise "Set FILE=path/to/artists.csv" if path.blank?

    dry = ENV["DRY_RUN"].to_s == "1"
    expected = %w[id name pronouns city genre genre_list social tags]

    updated = 0
    skipped = 0

    CSV.open(path, "r:BOM|UTF-8", headers: true, header_converters: :downcase) do |csv|
      missing = expected - csv.headers.map(&:to_s)
      raise "CSV missing columns: #{missing.join(', ')}" if missing.any?

      csv.each do |row|
        id = row["id"].to_s.strip
        next if id.blank?

        artist = Artist.find_by(id: id)
        unless artist&.events&.exists?(city_key: "movement")
          warn "Skip: artist id=#{id} not on any Movement event"
          skipped += 1
          next
        end

        attrs = {
          name: row["name"].presence,
          pronouns: row["pronouns"].presence,
          city: row["city"].presence,
          genre_list: row["genre_list"].presence,
          social: row["social"].presence,
          tags: row["tags"].presence
        }

        gstr = row["genre"].to_s.strip
        if gstr.present?
          g =
            Genre.find_by_name_case_insensitive(Genre.canonical_name(gstr)) ||
            Genre.find_or_create_by_canonical_name!(gstr)
          attrs[:genre_id] = g.id
        else
          attrs[:genre_id] = nil
        end

        if dry
          puts "[DRY] would update artist #{id}: #{attrs.inspect}"
        else
          artist.update!(attrs)
        end
        updated += 1
      end
    end

    unless dry
      if updated.positive?
        Event.clear_public_index_cache!("movement")
        Event.clear_public_index_cache!("mmw")
      end
    end

    puts dry ? "DRY_RUN: would touch #{updated} artists (#{skipped} skipped)." : "Updated #{updated} artists (#{skipped} skipped)."
  end
end
