# frozen_string_literal: true

require "aws-sdk-s3"

def fetch_backup_from_s3
  s3_latest = ENV["BACKUP_S3_LATEST"] == "1"
  bucket = ENV["BACKUP_S3_BUCKET"].to_s.strip.presence || "movement-parties-prod-api-storage"
  s3_key = ENV["BACKUP_S3_KEY"].to_s.strip

  uri = ENV["BACKUP_S3_URI"].to_s.strip
  if uri.start_with?("s3://")
    rest = uri.delete_prefix("s3://")
    uri_bucket, uri_key = rest.split("/", 2)
    bucket = uri_bucket if uri_bucket.present?
    s3_key = uri_key if uri_key.present?
  end

  return nil unless s3_key.present? || s3_latest

  prefix = "db_backups/"
  s3 = Aws::S3::Client.new(region: ENV.fetch("AWS_REGION", "us-east-1"))

  key = if s3_latest
    resp = s3.list_objects_v2(bucket: bucket, prefix: prefix, max_keys: 1000)
    objs = resp.contents.sort_by(&:last_modified).reverse
    objs.first&.key
  else
    s3_key.start_with?(prefix) ? s3_key : "#{prefix}#{s3_key}"
  end

  return nil unless key

  local = Rails.root.join("tmp", "backup-from-s3.sql").to_s
  FileUtils.mkdir_p(File.dirname(local))
  s3.get_object(bucket: bucket, key: key, response_target: local)
  puts "  Downloaded from S3: #{bucket}/#{key}"
  local
end

# Resolves BACKUP_FILE when the path is wrong (e.g. /tmp/foo.sql vs Rails.root/tmp/foo.sql).
def resolve_backup_sql_path(path)
  return [nil, []] if path.blank?

  candidates = [
    path,
    Rails.root.join(path).to_s,
    Rails.root.join("tmp", path).to_s,
    Rails.root.join("tmp", File.basename(path)).to_s,
    Rails.root.join("db", File.basename(path)).to_s,
  ].uniq
  [candidates.find { |c| File.exist?(c) }, candidates]
end

# CITY unset or blank → movement only (avoids remapping MMW / other cities by accident).
# CITY=all → every city. CITY=mmw → Miami Music Week only.
def parse_remap_city_filter
  raw = ENV["CITY"].to_s.strip.downcase
  return nil if raw == "all"
  return "movement" if raw.blank?

  raw
end

def venue_logo_missing_or_broken?(venue)
  return true unless venue.logo.attached?
  return true unless ActiveStorage::Blob.service.respond_to?(:exist?)

  !venue.logo.blob.service.exist?(venue.logo.blob.key)
rescue StandardError
  true
end

# Default folder for attach_venue_logos_from_folder (Rails.root is api/)
def default_venue_logos_images_dir
  File.expand_path("../client/public/images", Rails.root)
end

namespace :db do
  desc "Restore Movement venues from backup. BACKUP_FILE=tmp/backup-mar8.sql or BACKUP_S3_LATEST=1"
  task restore_venues: :environment do
    resolved = fetch_backup_from_s3
    unless resolved
      path = ENV["BACKUP_FILE"]
      if path.blank?
        puts "Usage: BACKUP_FILE=/path/to/backup.sql rails db:restore_venues"
        puts "   or: BACKUP_S3_LATEST=1 rails db:restore_venues  (fetch most recent from S3)"
        puts "   or: BACKUP_S3_KEY=db_backups/backup-2026-03-17.sql rails db:restore_venues"
        puts ""
        puts "Options: CITY=movement (default), DRY_RUN=1 to preview"
        exit 1
      end

      resolved, tried = resolve_backup_sql_path(path)
      unless resolved
        puts "File not found: #{path}"
        puts "Tried: #{tried.join(', ')}"
        exit 1
      end
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

  desc "Restore Active Storage (logos) from backup. BACKUP_FILE=tmp/backup.sql or BACKUP_S3_LATEST=1"
  task restore_active_storage: :environment do
    resolved = fetch_backup_from_s3
    unless resolved
      path = ENV["BACKUP_FILE"]
      if path.blank?
        puts "Usage: BACKUP_FILE=/path/to/backup.sql rails db:restore_active_storage"
        puts "   or: BACKUP_S3_LATEST=1 rails db:restore_active_storage  (fetch most recent from S3)"
        puts "   or: BACKUP_S3_KEY=db_backups/backup-2026-03-17.sql"
        puts "   or: BACKUP_S3_URI=s3://movement-parties-prod-api-storage/db_backups/backup-2026-03-17.sql"
        exit 1
      end

      resolved, tried = resolve_backup_sql_path(path)
      unless resolved
        puts "File not found: #{path}"
        puts "Tried: #{tried.join(', ')}"
        exit 1
      end
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
          remap_venue_attachment_record_ids(content: content, abs_path: abs_path, city_filter: nil)
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

  # Logo recovery playbook (Movement legacy venues are especially prone to this):
  # 1) restore_active_storage loads blob + attachment rows from a pg_dump; record_id still
  #    refers to *backup* venue IDs. If current venues were re-seeded or IDs shifted, logos
  #    point at the wrong row or nowhere useful until remap runs.
  # 2) rails db:remap_venue_logos BACKUP_FILE=... (same SQL you used for restore) rewrites
  #    active_storage_attachments.record_id to match current Venue rows by name + city_key.
  #    Defaults to CITY=movement only; use CITY=all to remap every city, or CITY=mmw for MMW.
  # 3) If remap can't match (renamed venues, duplicates), fix in Rails admin: detach broken
  #    logo and re-upload — that creates a fresh blob + attachment tied to the real venue id.
  # 4) Run db:audit_venue_logos to see missing logos vs orphan attachments before/after.

  desc "Report venue logo health: missing attachments, orphan attachments (wrong record_id)"
  task audit_venue_logos: :environment do
    city = ENV["CITY"] || "movement"
    venues = Venue.where(city_key: city).order(:id)
    missing = venues.reject { |v| v.logo.attached? }

    venue_ids = Venue.pluck(:id)
    orphans = ActiveStorage::Attachment
      .where(record_type: "Venue", name: "logo")
      .where.not(record_id: venue_ids)

    puts "Venue logos audit (city_key=#{city})"
    puts "  Venues: #{venues.size}"
    puts "  Missing logo attachment: #{missing.size}"
    missing.first(30).each { |v| puts "    - id=#{v.id} #{v.name}" }
    puts "    … (#{missing.size - 30} more)" if missing.size > 30

    puts "  Orphan logo attachments (record_id is not a venue id): #{orphans.count}"
    orphans.limit(40).find_each do |att|
      puts "    - attachment id=#{att.id} record_id=#{att.record_id} blob_id=#{att.blob_id}"
    end
    puts "    … (truncated)" if orphans.count > 40

    puts "\nNext steps:"
    puts "  - Many orphans: run db:remap_venue_logos with the SAME backup SQL used for restore_active_storage"
    puts "  - Many missing: re-upload logos in Rails admin for those venues (or fix S3 + attachments)"
    puts "  - After fixes: CITY=#{city} rails db:audit_venue_logos again"
    puts "  - URLs in JSON but files 404: CITY=#{city} rails db:audit_venue_logos_s3"
  end

  desc "HEAD each venue logo blob in S3 (same bucket as MMW). CITY=movement|mmw|all"
  task audit_venue_logos_s3: :environment do
    raw = ENV["CITY"].to_s.strip.downcase
    cities =
      if raw.blank? || raw == "all"
        %w[movement mmw]
      else
        [raw]
      end

    unless ActiveStorage::Blob.service.respond_to?(:exist?)
      puts "Active Storage service has no exist? — cannot audit (not S3 disk service?)"
      exit 1
    end

    cities.each do |city|
      puts "\n=== city_key=#{city} ==="
      ok = 0
      missing_s3 = 0
      no_logo = 0

      Venue.where(city_key: city).order(:id).find_each do |v|
        unless v.logo.attached?
          no_logo += 1
          next
        end

        blob = v.logo.blob
        if blob.service.exist?(blob.key)
          ok += 1
        else
          missing_s3 += 1
          puts "  MISSING_IN_S3 venue_id=#{v.id} name=#{v.name.inspect} blob_id=#{blob.id} key=#{blob.key}"
        end
      end

      puts "  Summary: ok=#{ok} missing_in_s3=#{missing_s3} no_attachment=#{no_logo}"
    end

    puts "\nMISSING_IN_S3 means the DB points at an object key that is not in the bucket."
    puts "Re-upload in Rails admin (or restore blobs from a backup that matches those keys)."
    puts "Or: SOURCE_BUCKET=your-old-bucket rails db:sync_missing_venue_logos_from_s3_bucket (same keys)"
    puts "Or: rails db:relink_missing_venue_logos_by_checksum (same file uploaded twice → another blob may still exist)"
  end

  desc "Copy missing venue logo objects from SOURCE_BUCKET into current AS bucket (same key). DRY_RUN=1 CITY=movement"
  task sync_missing_venue_logos_from_s3_bucket: :environment do
    src_bucket = ENV["SOURCE_BUCKET"].to_s.strip
    if src_bucket.blank?
      puts "Usage: SOURCE_BUCKET=name-of-backup-s3-bucket rails db:sync_missing_venue_logos_from_s3_bucket"
      puts "Requires AWS creds that can read SOURCE_BUCKET and write the Active Storage bucket (storage.yml amazon)."
      puts "Options: CITY=movement (default) | mmw | all    DRY_RUN=1 to list only"
      exit 1
    end

    unless ActiveStorage::Blob.service.respond_to?(:exist?)
      puts "Active Storage service has no exist? — not S3."
      exit 1
    end

    amz = Rails.application.config.active_storage.service_configurations&.dig("amazon") || {}
    dest_bucket = amz["bucket"].presence || "movement-parties-assets"
    region = amz["region"].presence || "us-east-1"
    dry_run = ENV["DRY_RUN"] == "1"

    raw = ENV["CITY"].to_s.strip.downcase
    cities =
      if raw.blank? || raw == "all"
        %w[movement mmw]
      else
        [raw]
      end

    s3 = Aws::S3::Client.new(
      region: region,
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    )

    copied = 0
    skipped_dest_ok = 0
    skipped_no_source = 0

    cities.each do |city|
      puts "\n=== city_key=#{city} ==="
      Venue.where(city_key: city).order(:id).find_each do |v|
        next unless v.logo.attached?

        blob = v.logo.blob
        key = blob.key

        if blob.service.exist?(key)
          skipped_dest_ok += 1
          next
        end

        begin
          s3.head_object(bucket: src_bucket, key: key)
        rescue Aws::S3::Errors::NotFound
          puts "  NO_SOURCE venue_id=#{v.id} #{v.name.inspect} key=#{key}"
          skipped_no_source += 1
          next
        end

        if dry_run
          puts "  WOULD_COPY key=#{key} <- #{src_bucket}"
          copied += 1
          next
        end

        s3.copy_object(
          bucket: dest_bucket,
          key: key,
          copy_source: "#{src_bucket}/#{key}"
        )
        puts "  COPIED key=#{key} venue_id=#{v.id} #{v.name.inspect}"
        copied += 1
      end
    end

    puts "\nSummary: copied=#{copied} skipped_already_in_dest=#{skipped_dest_ok} skipped_no_source=#{skipped_no_source} dry_run=#{dry_run}"
  end

  desc "Relink missing S3 logos to another blob with same checksum if that file exists (dedupe recovery). DRY_RUN=1 CITY=movement"
  task relink_missing_venue_logos_by_checksum: :environment do
    unless ActiveStorage::Blob.service.respond_to?(:exist?)
      puts "Active Storage service has no exist? — not S3."
      exit 1
    end

    dry_run = ENV["DRY_RUN"] == "1"
    city = ENV["CITY"].presence || "movement"
    weak = ENV["WEAK_MATCH"] == "1"

    puts "Indexing blobs whose keys exist in S3…"
    good_by_checksum = {}
    good_by_weak = {}

    ActiveStorage::Blob.find_each do |b|
      next unless b.service.exist?(b.key)

      good_by_checksum[b.checksum] ||= b if b.checksum.present?
      if weak
        sig = "#{b.byte_size}:#{b.content_type}"
        good_by_weak[sig] ||= b
      end
    end

    puts "Checksums with at least one live object: #{good_by_checksum.size}"
    puts "WEAK_MATCH=1 also matches byte_size+content_type (riskier duplicates)" if weak

    relinked = 0
    no_match = 0

    Venue.where(city_key: city).find_each do |v|
      next unless v.logo.attached?

      bad = v.logo.blob
      next if bad.service.exist?(bad.key)

      good = nil
      if bad.checksum.present?
        g = good_by_checksum[bad.checksum]
        good = g if g && g.id != bad.id
      end

      if good.nil? && weak && bad.checksum.blank?
        sig = "#{bad.byte_size}:#{bad.content_type}"
        g = good_by_weak[sig]
        good = g if g && g.id != bad.id
      end

      unless good
        puts "  NO_MATCH venue_id=#{v.id} #{v.name.inspect} blob_id=#{bad.id} key=#{bad.key}"
        no_match += 1
        next
      end

      if dry_run
        puts "  WOULD_RELINK venue_id=#{v.id} #{v.name.inspect} blob #{bad.id} -> #{good.id} (same checksum)"
        relinked += 1
        next
      end

      v.logo.attachment.update_column(:blob_id, good.id)
      puts "  RELINKED venue_id=#{v.id} #{v.name.inspect} blob #{bad.id} -> #{good.id}"
      relinked += 1
    end

    unless dry_run
      Event.clear_public_index_cache!(city)
      puts "Cleared Rails events index cache for #{city}"
    end

    puts "\nSummary: relinked=#{relinked} no_duplicate_found=#{no_match} dry_run=#{dry_run}"
    puts "If still broken: S3 bucket versioning (restore deleted objects), another SOURCE_BUCKET, or re-upload in admin."
  end

  desc "Upload local images to venue logos. Default: ../client/public/images. MATCH_BY=image_filename|name|id"
  task attach_venue_logos_from_folder: :environment do
    raw_dir = ENV["IMAGES_DIR"].to_s.strip
    dir =
      if raw_dir.blank?
        default_venue_logos_images_dir
      else
        File.expand_path(raw_dir, Rails.root)
      end

    unless Dir.exist?(dir)
      puts "Directory not found: #{dir}"
      puts "Usage: IMAGES_DIR=path/to/folder rails db:attach_venue_logos_from_folder"
      puts "  Default IMAGES_DIR is #{default_venue_logos_images_dir} (client/public/images from repo root)"
      puts "  MATCH_BY=image_filename: use each venue's DB image_filename as the file name in that folder"
      puts "  MATCH_BY=name (default): filename stem matches venue.name (e.g. hart-plaza.png)"
      puts "  MATCH_BY=id: files named 6.png, 21.jpg for venue id"
      puts "  ONLY_MISSING=0: overwrite even if logo already OK in S3 (default ONLY_MISSING=1)"
      exit 1
    end

    match_by = ENV["MATCH_BY"].to_s.downcase.presence || "name"
    city = ENV["CITY"].presence || "movement"
    dry_run = ENV["DRY_RUN"] == "1"
    only_missing = ENV["ONLY_MISSING"] != "0"

    cities_for_image_filename =
      if city.to_s.strip.downcase == "all"
        %w[movement mmw]
      else
        [city]
      end

    puts "Using directory: #{dir}"
    puts "MATCH_BY=#{match_by} CITY=#{city} ONLY_MISSING=#{only_missing} dry_run=#{dry_run}"

    attached = 0
    skipped_no_venue = 0
    skipped_ok_logo = 0
    missing_file = 0
    skipped_no_image_filename = 0

    if match_by == "image_filename"
      cities_for_image_filename.each do |city_key|
        puts "\n--- city_key=#{city_key} ---"
        Venue.where(city_key: city_key).order(:id).find_each do |venue|
          if venue.image_filename.blank?
            skipped_no_image_filename += 1
            next
          end

          safe_name = File.basename(venue.image_filename.to_s)
          path = File.join(dir, safe_name)

          unless File.file?(path)
            puts "  MISSING_FILE venue_id=#{venue.id} #{venue.name.inspect} image_filename=#{venue.image_filename.inspect}"
            missing_file += 1
            next
          end

          if only_missing && !venue_logo_missing_or_broken?(venue)
            puts "  SKIP_OK venue_id=#{venue.id} #{venue.name.inspect} — ONLY_MISSING=0 to replace"
            skipped_ok_logo += 1
            next
          end

          if dry_run
            puts "  WOULD_ATTACH venue_id=#{venue.id} #{venue.name.inspect} <- #{path}"
            attached += 1
            next
          end

          File.open(path, "rb") do |io|
            venue.logo.attach(io: io, filename: safe_name)
          end
          puts "  ATTACHED venue_id=#{venue.id} #{venue.name.inspect} <- #{path}"
          attached += 1
        end
      end
    else
      venues = Venue.where(city_key: city).to_a
      by_param = venues.index_by { |v| v.name.to_s.parameterize }
      by_id = venues.index_by(&:id)

      exts = %w[png jpg jpeg webp gif avif]
      files = Dir.children(dir).filter_map do |name|
        path = File.join(dir, name)
        next unless File.file?(path)

        ext = File.extname(name).delete(".")
        next unless exts.include?(ext.downcase)

        path
      end.sort

      if files.empty?
        puts "No image files (.png/.jpg/.jpeg/.webp/.gif/.avif) in #{dir}"
        exit 0
      end

      puts "Found #{files.size} image(s) in #{dir}"

      files.each do |path|
        stem = File.basename(path, ".*")
        venue = if match_by == "id"
                    id = stem.to_i
                    id.positive? ? by_id[id] : nil
                  else
                    by_param[stem.parameterize]
                  end

        unless venue
          puts "  NO_VENUE for file #{path.inspect} (stem=#{stem.inspect})"
          skipped_no_venue += 1
          next
        end

        if only_missing && !venue_logo_missing_or_broken?(venue)
          puts "  SKIP_OK (logo already in S3) venue_id=#{venue.id} #{venue.name.inspect} — use ONLY_MISSING=0 to replace"
          skipped_ok_logo += 1
          next
        end

        if dry_run
          puts "  WOULD_ATTACH venue_id=#{venue.id} #{venue.name.inspect} <- #{path}"
          attached += 1
          next
        end

        File.open(path, "rb") do |io|
          venue.logo.attach(io: io, filename: File.basename(path))
        end
        puts "  ATTACHED venue_id=#{venue.id} #{venue.name.inspect} <- #{path}"
        attached += 1
      end
    end

    unless dry_run
      if match_by == "image_filename"
        cities_for_image_filename.each { |ck| Event.clear_public_index_cache!(ck) }
        puts "Cleared Rails events index cache for: #{cities_for_image_filename.join(', ')}"
      else
        Event.clear_public_index_cache!(city)
        puts "Cleared Rails events index cache for #{city}"
      end
    end

    if match_by == "image_filename"
      puts "\nSummary: attached=#{attached} missing_file=#{missing_file} skipped_ok_logo=#{skipped_ok_logo} skipped_no_image_filename=#{skipped_no_image_filename} dry_run=#{dry_run}"
      puts "Put files in #{dir} using names from venues.image_filename (see MISSING_FILE lines)."
    else
      puts "\nSummary: attached=#{attached} no_matching_venue=#{skipped_no_venue} skipped_already_ok=#{skipped_ok_logo}"
      puts "Naming: hart-plaza.png (MATCH_BY=name) or 21.png (MATCH_BY=id), or MATCH_BY=image_filename for DB filenames."
    end
  end

  desc "Remap Venue attachment record_ids to match current venue IDs (run after restore_active_storage if venue IDs changed)"
  task remap_venue_logos: :environment do
    resolved = fetch_backup_from_s3
    unless resolved
      path = ENV["BACKUP_FILE"]
      if path.blank?
        puts "Usage: BACKUP_FILE=/path/to/backup.sql rails db:remap_venue_logos"
        puts "   or: BACKUP_S3_LATEST=1 rails db:remap_venue_logos"
        puts "Options: CITY=movement (default) | CITY=mmw | CITY=all"
        exit 1
      end
      resolved, tried = resolve_backup_sql_path(path)
      unless resolved
        puts "File not found: #{path}"
        puts "Tried: #{tried.join(', ')}"
        exit 1
      end
    end
    abs_path = File.absolute_path(resolved, Rails.root)
    content = File.read(abs_path)
    remap_venue_attachment_record_ids(content: content, abs_path: abs_path, city_filter: parse_remap_city_filter)
  end

  desc "Alias for remap_venue_logos (typo: missing 's')"
  task remap_venue_logo: :remap_venue_logos

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

def remap_venue_attachment_record_ids(content:, abs_path: nil, city_filter: nil)
  # When running locally with RAILS_ENV=production, .env.production may not be loaded.
  # Force DATABASE_URL so we connect to the right DB (not default "carlymarsh").
  env_file = Rails.root.join(".env.production")
  if Rails.env.production? && File.exist?(env_file)
    File.foreach(env_file) do |line|
      line = line.strip
      next if line.blank? || line.start_with?("#")
      key, val = line.split("=", 2)
      next unless key && val
      val = val.gsub(/\A["']|["']\z/, "")
      ENV[key] ||= val
    end
  end
  if ENV["DATABASE_URL"].present?
    ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"])
  end

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
  backup_ids_by_name_city = Hash.new { |h, k| h[k] = [] } # [name, city] -> [backup_ids in order]
  venues_match[2].each_line do |line|
    next if line.strip == "\\."
    vals = line.chomp.split("\t")
    next if vals.size < columns.size
    bid = vals[id_idx]&.to_i
    name = (vals[name_idx] || "").to_s.strip
    city = (vals[city_idx] || "").to_s.strip.presence || "movement"
    next if bid.blank? || name.blank?
    backup_venue[bid] = { name: name, city_key: city }
    key = [name.downcase, city]
    backup_ids_by_name_city[key] << bid
  end
  backup_ids_by_name_city.each_value(&:sort!)

  if city_filter.present?
    puts "  Remapping only city_key=#{city_filter} (use CITY=all for every city)"
  else
    puts "  Remapping all cities"
  end

  remapped = 0
  skipped_other_city = 0
  ActiveStorage::Attachment.where(record_type: "Venue", name: "logo").find_each do |att|
    backup_id = att.record_id
    info = backup_venue[backup_id]
    next unless info

    if city_filter.present? && info[:city_key].to_s.downcase.strip != city_filter
      skipped_other_city += 1
      next
    end

    key = [info[:name].downcase, info[:city_key]]
    backup_ids = backup_ids_by_name_city[key]
    idx = backup_ids&.index(backup_id)
    current_venues = Venue.where(city_key: info[:city_key])
                          .select { |v| v.name.to_s.strip.casecmp(info[:name].to_s.strip).zero? }
                          .sort_by(&:id)
    current = if idx && current_venues.size > idx
                current_venues[idx]
              else
                Venue.find_by(name: info[:name], city_key: info[:city_key]) ||
                  current_venues.first
              end
    next unless current
    next if current.id == backup_id

    att.update_column(:record_id, current.id)
    remapped += 1
    puts "  Remapped: #{info[:name]} [city_key=#{info[:city_key]}] (#{backup_id} -> #{current.id})"
  end

  puts "  Skipped #{skipped_other_city} attachment(s) (other city_key; not in this run)" if city_filter.present? && skipped_other_city > 0
  if remapped > 0
    puts "  Remapped #{remapped} Venue logo attachments to current IDs"
  elsif city_filter.present?
    puts "  No logos remapped for city_key=#{city_filter}. Try db:audit_venue_logos or CITY=all."
  end
end
