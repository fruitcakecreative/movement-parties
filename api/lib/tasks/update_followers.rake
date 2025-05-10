namespace :update do
  desc "Update RA followers for all artists"
  task followers: :environment do
    require 'open3'

    Artist.where(ra_followers: nil).find_each do |artist|
      slug = artist.name.downcase.gsub(/\s+/, "") # crude slug fallback
      puts "🔍 Fetching for #{artist.name} (slug: #{slug})..."

      output, _ = Open3.capture2("python3 follower_scraper.py #{slug}")
      count = output.to_i

      if count > 0
        artist.update(ra_followers: count)
        puts "✅ Saved #{count} followers"
      else
        puts "⚠️ Could not fetch followers"
      end
    end
  end
end
