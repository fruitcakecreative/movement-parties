# frozen_string_literal: true

require "csv"

# Round-trip for CSVs from export:movement_* tasks. Updates existing rows by id only (no creates).
# Use data/exports/ under api/ (git-tracked) — not tmp/ (gitignored).
# Paths below are relative to the api/ directory (where you run bin/rails).
#
#   FILE=data/exports/movement_venues.csv  bin/rails import:movement_venues_csv
#   FILE=data/exports/movement_events.csv bin/rails import:movement_events_csv
#   FILE=data/exports/movement_artists.csv bin/rails import:movement_artists_csv
#
# Preview: DRY_RUN=1 FILE=data/exports/movement_artists.csv bin/rails import:movement_artists_csv
#
# Full DB restore from pg_dump / S3 is separate — use pg_restore or psql.

module MovementCsvImport
  module_function

  # CSV.read returns CSV::Table — .headers is an Array (CSV.open's reader uses headers as a boolean flag).
  def table(path)
    CSV.read(path, headers: true, header_converters: :downcase, encoding: "BOM|UTF-8")
  end

  # Columns from export:movement_events (+ optional "venue" for venue name → venue_id).
  def attrs_for_movement_event_row(row, header_list)
    hdr = ->(key) { header_list.include?(key) }
    attrs = {}

    %w[title description ticket_url ticket_tier indoor_outdoor age promoter manual_artist_names event_image_url dice_url].each do |key|
      next unless hdr.call(key)

      attrs[key.to_sym] = row[key].presence
    end

    if hdr.call("ticket_price")
      tp = row["ticket_price"]
      attrs[:ticket_price] = tp.blank? ? nil : BigDecimal(tp.to_s)
    end

    %w[free_event food_available].each do |key|
      next unless hdr.call(key)

      raw = row[key]
      next if raw.nil? || raw.to_s.strip.empty?

      attrs[key.to_sym] = ActiveModel::Type::Boolean.new.cast(raw)
    end

    attrs
  end
end

namespace :import do
  desc "Update Movement venues from CSV (same columns as export:movement_venues). FILE= required. DRY_RUN=1 to preview."
  task movement_venues_csv: :environment do
    path = ENV["FILE"].to_s.strip.presence
    raise "Set FILE=path/to/venues.csv" if path.blank?

    dry = ENV["DRY_RUN"].to_s == "1"
    expected = %w[id name location venue_type serves_alcohol venue_url address description age]

    updated = 0
    skipped = 0

    table = MovementCsvImport.table(path)
    missing = expected - table.headers.map(&:to_s)
    raise "CSV missing columns: #{missing.join(', ')}" if missing.any?

    table.each do |row|
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

    puts dry ? "DRY_RUN: would touch #{updated} venues (#{skipped} skipped)." : "Updated #{updated} venues (#{skipped} skipped)."
  end

  desc "Update Movement events from CSV (export:movement_events shape; required column: id). Optional venue column = venue name → venue_id. DRY_RUN=1 to preview."
  task movement_events_csv: :environment do
    path = ENV["FILE"].to_s.strip.presence
    raise "Set FILE=path/to/events.csv" if path.blank?

    dry = ENV["DRY_RUN"].to_s == "1"

    updated = 0
    skipped = 0

    table = MovementCsvImport.table(path)
    header_list = table.headers.map(&:to_s)
    raise "CSV must include an id column" unless header_list.include?("id")

    table.each do |row|
      id = row["id"].to_s.strip
      next if id.blank?

      event = Event.find_by(id: id, city_key: "movement")
      unless event
        warn "Skip: no Movement event id=#{id}"
        skipped += 1
        next
      end

      attrs = MovementCsvImport.attrs_for_movement_event_row(row, header_list)

      if header_list.include?("venue")
        venue_name = row["venue"].to_s.strip
        if venue_name.present?
          v =
            Venue.where(city_key: "movement").where(
              "LOWER(TRIM(name)) = ?",
              venue_name.downcase
            ).first
          if v
            attrs[:venue_id] = v.id
          else
            warn "Venue not found for event #{id} (keeping venue_id=#{event.venue_id}): #{venue_name.inspect}"
          end
        end
      end

      if dry
        puts "[DRY] would update event #{id}: #{attrs.inspect}"
      else
        event.update!(attrs)
      end
      updated += 1
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

    table = MovementCsvImport.table(path)
    missing = expected - table.headers.map(&:to_s)
    raise "CSV missing columns: #{missing.join(', ')}" if missing.any?

    table.each do |row|
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

    unless dry
      if updated.positive?
        Event.clear_public_index_cache!("movement")
        Event.clear_public_index_cache!("mmw")
      end
    end

    puts dry ? "DRY_RUN: would touch #{updated} artists (#{skipped} skipped)." : "Updated #{updated} artists (#{skipped} skipped)."
  end
end
