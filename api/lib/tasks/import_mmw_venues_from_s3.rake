require "aws-sdk-s3"
require "csv"

namespace :import do
  desc "Update MMW venue fields from S3 CSV (venues/mmw_venues.csv)"
  task mmw_venues_from_s3: :environment do
    city   = "mmw"
    bucket = ENV.fetch("S3_BUCKET", "mmw-parties-events-data")
    key    = ENV.fetch("S3_KEY", "venues/mmw_venues.csv")

    s3 = Aws::S3::Client.new(region: "us-east-1")
    path = "/tmp/mmw_venues.csv"
    s3.get_object(bucket: bucket, key: key, response_target: path)

    updated = 0
    created = 0
    skipped = 0

    CSV.foreach(path, headers: true) do |row|
      name = row["name"]&.strip
      if name.blank?
        skipped += 1
        next
      end

      venue = Venue.where(city_key: city).where("lower(name) = ?", name.downcase).first
      is_new = venue.nil?
      venue ||= Venue.new(city_key: city, name: name)

      attrs = {}
      %w[location image_filename venue_url address bg_color font_color].each do |k|
        v = row[k]&.strip
        next if v.blank?
        attrs[k] = v
      end

      venue.assign_attributes(attrs)
      if venue.changed?
        venue.save!
        is_new ? created += 1 : updated += 1
      end
    end

    Rails.cache.delete("events-v1:mmw") rescue nil
    puts "MMW venues: created=#{created} updated=#{updated} skipped=#{skipped}"
  end
end
