# frozen_string_literal: true

# Attach venue logos from disk using venues.image_filename (basename = filename in folder).
#   rails backfill:venue_logos
#   DRY_RUN=1 rails backfill:venue_logos
#   ONLY_MISSING=0 rails backfill:venue_logos   # replace even when S3 already has the file
# Production (when client/ is not on the server): copy images to the host, then e.g.
#   VENUE_LOGOS_DIR=/path/to/images rails backfill:venue_logos

module Backfill
  module VenueLogoFromImages
    DEFAULT_IMAGES_DIR = File.expand_path("../client/public/images", Rails.root)

    def self.images_dir
      base = ENV["VENUE_LOGOS_DIR"].presence
      base ? File.expand_path(base) : DEFAULT_IMAGES_DIR
    end

    def self.needs_attach?(venue)
      return true unless venue.logo.attached?
      return true unless ActiveStorage::Blob.service.respond_to?(:exist?)

      !venue.logo.blob.service.exist?(venue.logo.blob.key)
    rescue StandardError
      true
    end
  end
end

namespace :backfill do
  desc "Attach venue logos from client/public/images (matches venues.image_filename)"
  task venue_logos: :environment do
    dir = Backfill::VenueLogoFromImages.images_dir
    dry_run = ENV["DRY_RUN"] == "1"
    only_missing = ENV["ONLY_MISSING"] != "0"

    unless Dir.exist?(dir)
      abort "Images folder not found: #{dir}\nPut files there named like each venue's image_filename."
    end

    puts "Folder: #{dir}"
    puts "dry_run=#{dry_run}  only_missing=#{only_missing}  (set ONLY_MISSING=0 to overwrite good logos)"

    attached = 0
    skipped_ok = 0
    missing_file = 0
    blank_fn = 0

    Venue.order(:id).find_each do |venue|
      if venue.image_filename.blank?
        blank_fn += 1
        next
      end

      safe_name = File.basename(venue.image_filename.to_s)
      path = File.join(dir, safe_name)

      unless File.file?(path)
        puts "MISSING_FILE  id=#{venue.id}  #{venue.name}  → #{venue.image_filename}"
        missing_file += 1
        next
      end

      if only_missing && !Backfill::VenueLogoFromImages.needs_attach?(venue)
        skipped_ok += 1
        next
      end

      if dry_run
        puts "WOULD_ATTACH  id=#{venue.id}  #{venue.name}  ← #{path}"
        attached += 1
        next
      end

      File.open(path, "rb") do |io|
        venue.logo.attach(io: io, filename: safe_name)
      end
      puts "ATTACHED  id=#{venue.id}  #{venue.name}"
      attached += 1
    end

    unless dry_run
      %w[movement mmw].each { |ck| Event.clear_public_index_cache!(ck) }
      puts "Cleared events index cache (movement, mmw)."
    end

    puts "\nDone. attached=#{attached}  missing_file=#{missing_file}  skipped_already_ok=#{skipped_ok}  blank_image_filename=#{blank_fn}"
  end
end
