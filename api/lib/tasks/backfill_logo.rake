
namespace :backfill do
  desc "Attach logos to venues from image_filename"
  task venue_logos: :environment do
    Venue.find_each do |venue|
      next if venue.image_filename.blank?

      path = Rails.root.join("../client/public/images/#{venue.image_filename}")
      unless File.exist?(path)
        puts "❌ Missing: #{venue.name} → #{venue.image_filename}"
        next
      end

      venue.logo.purge if venue.logo.attached?
      venue.logo.attach(
        io: File.open(path),
        filename: venue.image_filename,
        content_type: "image/png"
      )
      puts "✅ Re-attached logo for #{venue.name}"
    end
  end

end
