# frozen_string_literal: true

namespace :db do
  desc "Restore Movement venues from backup. BACKUP_FILE=tmp/backup-mar8.sql"
  task restore_venues: :environment do
    path = ENV["BACKUP_FILE"]
    if path.blank?
      puts "Usage: BACKUP_FILE=/path/to/backup.sql rails db:restore_venues"
      puts "   or: BACKUP_FILE=/path/to/venues.json rails db:restore_venues"
      puts ""
      puts "Options: CITY=movement (default), DRY_RUN=1 to preview"
      puts ""
      puts "To export venues from a SQL backup to JSON first:"
      puts "  pg_restore -t venues backup.dump 2>/dev/null | psql $DATABASE_URL -t -A -c \"\\copy (SELECT * FROM venues WHERE city_key='movement') TO 'venues.json'\""
      puts "  Or use a backup.sql and run: BACKUP_FILE=backup.sql rails db:restore_venues"
      exit 1
    end

    resolved = File.exist?(path) ? path : nil
    unless resolved
      candidates = [path]
      unless path.start_with?("/")
        candidates += [
          Rails.root.join(path).to_s,
          Rails.root.join("tmp", path).to_s,
          Rails.root.join("tmp", File.basename(path)).to_s,
        ]
      end
      resolved = candidates.uniq.find { |c| File.exist?(c) }
    end

    unless resolved
      puts "File not found: #{path}"
      puts "Tried: #{candidates.uniq.join(', ')}"
      exit 1
    end

    path = resolved
    city = ENV["CITY"] || "movement"
    dry_run = ENV["DRY_RUN"] == "1"

    puts "Restoring #{city} venues from #{path}"
    puts "DRY RUN - no changes will be made" if dry_run

    if path.end_with?(".json")
      restore_from_json(path, city: city, dry_run: dry_run)
    else
      restore_from_sql(path, city: city, dry_run: dry_run)
    end

  end

  desc "Restore Active Storage (logos) from backup. BACKUP_FILE=tmp/backup.sql"
  task restore_active_storage: :environment do
    path = ENV["BACKUP_FILE"]
    if path.blank?
      puts "Usage: BACKUP_FILE=/path/to/backup.sql rails db:restore_active_storage"
      exit 1
    end

    resolved = File.exist?(path) ? path : nil
    unless resolved
      candidates = [path]
      unless path.start_with?("/")
        candidates += [
          Rails.root.join(path).to_s,
          Rails.root.join("tmp", path).to_s,
          Rails.root.join("tmp", File.basename(path)).to_s,
        ]
      end
      resolved = candidates.uniq.find { |c| File.exist?(c) }
    end

    unless resolved
      puts "File not found: #{path}"
      exit 1
    end

    dry_run = ENV["DRY_RUN"] == "1"
    puts "Restoring Active Storage from #{resolved}"
    puts "DRY RUN - no changes" if dry_run

    # Use absolute path so CWD doesn't affect file read
    abs_path = File.absolute_path(resolved, Rails.root)
    content = File.read(abs_path)
    tables = %w[active_storage_blobs active_storage_attachments active_storage_variant_records]
    extracted = []

    # pg_dump COPY blocks end with a line containing only backslash-dot
    terminator = Regexp.escape("\\.")
    tables.each do |table|
      pattern = Regexp.new(
        "COPY\\s+(?:public\\.)?#{table}\\s+\\([^)]+\\)\\s+FROM\\s+stdin;\\n(.*?)^#{terminator}\\n",
        Regexp::MULTILINE
      )
      match = content.match(pattern)
      if match
        extracted << { table: table, block: match[0] }
        puts "  Found: #{table} (#{match[1].lines.size} rows)"
      else
        puts "  ⚠ Not found: #{table}"
      end
    end

    if extracted.empty?
      puts "No active_storage data found in backup"
      exit 1
    end

    unless dry_run
      temp = Tempfile.new(["active_storage_restore", ".sql"])
      begin
        temp.write("-- Restore Active Storage\n")
        temp.write("TRUNCATE active_storage_attachments, active_storage_variant_records, active_storage_blobs CASCADE;\n\n")
        extracted.each { |e| temp.write(e[:block]) }
        temp.rewind

        db_url = ENV["DATABASE_URL"] || "postgresql://localhost/mp_development"
        success = system("psql", db_url, "-v", "ON_ERROR_STOP=1", "-f", temp.path)
        if success
          puts "✅ Restored Active Storage"
          remap_venue_attachment_record_ids(content: content, abs_path: abs_path)
        else
          puts "❌ Restore failed - check output above"
          exit 1
        end
      ensure
        temp.close
        temp.unlink
      end
    end
  end

  desc "Remap Venue attachment record_ids to match current venue IDs (run after restore_active_storage if venue IDs changed)"
  task remap_venue_logos: :environment do
    path = ENV["BACKUP_FILE"]
    if path.blank?
      puts "Usage: BACKUP_FILE=/path/to/backup.sql rails db:remap_venue_logos"
      exit 1
    end
    resolved = File.exist?(path) ? path : nil
    unless resolved
      candidates = [path]
      candidates += [Rails.root.join(path).to_s, Rails.root.join("tmp", path).to_s, Rails.root.join("tmp", File.basename(path)).to_s] unless path.start_with?("/")
      resolved = candidates.uniq.find { |c| File.exist?(c) }
    end
    unless resolved
      puts "File not found: #{path}"
      exit 1
    end
    abs_path = File.absolute_path(resolved, Rails.root)
    content = File.read(abs_path)
    remap_venue_attachment_record_ids(content: content, abs_path: abs_path)
  end

  desc "Export venues to JSON backup (e.g. for restore_venues)"
  task export_venues: :environment do
    city = ENV["CITY"] || "movement"
    path = ENV["OUTPUT"] || Rails.root.join("db", "venues_backup_#{city}_#{Time.now.utc.strftime('%Y%m%d')}.json").to_s

    venues = Venue.where(city_key: city).as_json(except: %w[created_at updated_at])
    File.write(path, JSON.pretty_generate(venues))
    puts "Exported #{venues.size} #{city} venues to #{path}"
  end
end

def restore_from_json(path, city:, dry_run:)
  data = JSON.parse(File.read(path))
  data = data["venues"] if data.is_a?(Hash) && data.key?("venues")
  venues = Array(data).select { |v| (v["city_key"] || v[:city_key]).to_s == city }

  puts "Found #{venues.size} #{city} venues in JSON"

  restored = 0
  venues.each do |attrs|
    attrs = attrs.deep_stringify_keys
    name = attrs["name"]
    next if name.blank?
    next if name.to_s.downcase.include?("tba")

    existing = Venue.find_by(name: name, city_key: city) ||
               Venue.where(city_key: city).find { |v| v.name.to_s.strip.casecmp(name.to_s.strip).zero? }
    json_venue_attrs = %w[
      description address location venue_type subheading bg_color font_color
      venue_url image_filename notes parent_section_label age capacity distance
      serves_alcohol additional_images
    ]
    if existing
      updatable = attrs.slice(*json_venue_attrs).compact
      if !dry_run && updatable.any?
        existing.update!(updatable)
        restored += 1
        puts "  Updated: #{existing.name} (#{updatable.keys.join(', ')})"
      elsif dry_run && updatable.any?
        puts "  Would update: #{name} (#{updatable.keys.join(', ')})"
        restored += 1
      end
    else
      create_attrs = attrs.slice("name", *json_venue_attrs).compact
      create_attrs["city_key"] = city
      unless dry_run
        Venue.create!(create_attrs)
        restored += 1
        puts "  Created: #{name}"
      else
        puts "  Would create: #{name}"
        restored += 1
      end
    end
  end

  puts "\nRestored/updated #{restored} venues" unless dry_run
end

def restore_from_sql(path, city:, dry_run:)
  content = File.read(path)
  return restore_from_sql_copy(content, path, city: city, dry_run: dry_run) if content =~ /COPY\s+(?:public\.)?venues\s+.*FROM\s+stdin/i
  return restore_from_sql_insert(content, path, city: city, dry_run: dry_run) if content.include?("INSERT INTO")

  puts "Could not find venues data in SQL backup (expected COPY or INSERT)"
  exit 1
end

def parse_copy_columns(header_line)
  match = header_line.match(/COPY\s+(?:public\.)?venues\s*\(([^)]+)\)\s+FROM\s+stdin/i)
  return [] unless match

  match[1].split(",").map(&:strip).map { |c| c.gsub(/^"|"$/, "") }
end

def parse_tsv_row(line, columns)
  values = line.split("\t")
  return {} if values.size != columns.size

  columns.zip(values).to_h do |col, val|
    val = nil if val == "\\N" || val.blank?
    [col, val]
  end
end

def restore_from_sql_copy(content, _path, city:, dry_run:)
  lines = content.lines
  copy_start = lines.index { |l| l =~ /COPY\s+(?:public\.)?venues\s+.*FROM\s+stdin/i }
  unless copy_start
    puts "Could not find COPY venues block"
    exit 1
  end

  columns = parse_copy_columns(lines[copy_start])
  if columns.empty?
    puts "Could not parse COPY columns"
    exit 1
  end

  rows = []
  (copy_start + 1...lines.size).each do |i|
    line = lines[i]
    break if line.strip == "\\."

    rows << parse_tsv_row(line.chomp, columns)
  end

  venues = rows.select { |r| (r["city_key"] || r[:city_key]).to_s == city }
  puts "Found #{venues.size} #{city} venues in SQL backup"

  restore_venue_rows(venues, city: city, dry_run: dry_run)
end

def restore_from_sql_insert(content, _path, city:, dry_run:)
  # pg_dump with --inserts uses: INSERT INTO venues VALUES (1,'Name',...),(2,...);
  # This is harder to parse. Fall back to running a filtered extract.
  puts "INSERT format detected - extracting via temp file..."

  # Extract just the INSERT for venues and run it against a temp table, then copy?
  # Simpler: use ActiveRecord.connection.execute with a modified INSERT that has ON CONFLICT
  # Actually the safest: parse the VALUES to get rows. Complex.

  # Alternative: write a minimal SQL that creates temp table, inserts from backup, then
  # INSERT INTO venues SELECT ... WHERE city_key='movement' ON CONFLICT...
  # That requires parsing the schema from the backup.

  puts "For INSERT format, please export venues to JSON and use BACKUP_FILE=venues.json"
  puts "You can run: psql $DATABASE_URL -t -A -c \"SELECT json_agg(t) FROM (SELECT * FROM venues WHERE city_key='movement') t\" > venues.json"
  exit 1
end

def restore_venue_rows(rows, city:, dry_run:)
  venue_attrs = %w[
    name location capacity image_filename bg_color font_color subheading
    venue_type serves_alcohol notes venue_url address description distance
    additional_images hex_color age parent_section_label
  ].freeze

  restored = 0
  rows.each do |row|
    row = row.stringify_keys
    name = row["name"]
    next if name.blank?
    next if name.to_s.downcase.include?("tba")

    existing = Venue.find_by(name: name, city_key: city) ||
               Venue.where(city_key: city).find { |v| v.name.to_s.strip.casecmp(name.to_s.strip).zero? }
    attrs = row.slice(*venue_attrs)
    attrs["city_key"] = city
    attrs.delete("hex_color") # renamed to bg_color
    attrs["bg_color"] ||= row["hex_color"]

    if existing
      updatable = attrs.except("name", "city_key").compact
      if updatable.any?
        restored += 1
        if dry_run
          puts "  Would update: #{existing.name} (#{updatable.keys.join(', ')})"
        else
          existing.update!(updatable)
          puts "  Updated: #{existing.name} (#{updatable.keys.join(', ')})"
        end
      end
    else
      restored += 1
      if dry_run
        puts "  Would create: #{name}"
      else
        Venue.create!(attrs.compact)
        puts "  Created: #{name}"
      end
    end
  end

  puts "\nRestored/updated #{restored} venues" unless dry_run
end

def remap_venue_attachment_record_ids(content:, abs_path: nil)
  # Parse venues COPY block: backup venue id -> [name, city_key]
  terminator = Regexp.escape("\\.")
  venues_match = content.match(Regexp.new("COPY\\s+(?:public\\.)?venues\\s+\\(([^)]+)\\)\\s+FROM\\s+stdin;\\n(.*?)^#{terminator}\\n", Regexp::MULTILINE))
  unless venues_match
    puts "  (No venues block in backup - skipping record_id remap)"
    return
  end

  columns = venues_match[1].split(",").map(&:strip).map { |c| c.gsub(/^"|"$/, "") }
  id_idx = columns.index("id")
  name_idx = columns.index("name")
  city_idx = columns.index("city_key")
  unless id_idx && name_idx && city_idx
    puts "  (Could not parse venue columns - skipping record_id remap)"
    return
  end

  backup_venue = {} # backup_id -> { name:, city_key: }
  venues_match[2].each_line do |line|
    next if line.strip == "\\."
    vals = line.chomp.split("\t")
    next if vals.size < columns.size
    bid = vals[id_idx]&.to_i
    name = (vals[name_idx] || "").to_s.strip
    city = (vals[city_idx] || "").to_s.strip.presence || "movement"
    next if bid.blank? || name.blank?
    backup_venue[bid] = { name: name, city_key: city }
  end

  remapped = 0
  ActiveStorage::Attachment.where(record_type: "Venue", name: "logo").find_each do |att|
    backup_id = att.record_id
    info = backup_venue[backup_id]
    next unless info

    current = Venue.find_by(name: info[:name], city_key: info[:city_key]) ||
              Venue.where(city_key: info[:city_key]).find { |v| v.name.to_s.strip.casecmp(info[:name].to_s.strip).zero? }
    next unless current
    next if current.id == backup_id

    att.update_column(:record_id, current.id)
    remapped += 1
    puts "  Remapped: #{info[:name]} (#{backup_id} -> #{current.id})"
  end

  puts "  Remapped #{remapped} Venue logo attachments to current IDs" if remapped > 0
end
