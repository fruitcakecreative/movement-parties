# frozen_string_literal: true

namespace :db do
  desc "Normalize venue locations: combine similar values (e.g. 'miami beach' and 'Miami Beach')"
  task normalize_location: :environment do
    venues_with_location = Venue.where.not(location: [nil, ""])
    updated = 0

    venues_with_location.find_each do |venue|
      canonical = venue.location.to_s.strip.titleize
      next if venue.location == canonical

      old_loc = venue.location
      venue.update_column(:location, canonical) # skip callbacks to avoid recursion
      updated += 1
      puts "  #{venue.name}: '#{old_loc}' -> '#{canonical}'"
    end

    %w[movement mmw].each { |city| Rails.cache.delete("events-v1:#{city}") }
    puts "Normalized #{updated} venue locations"
  end

  task normalize_locations: :environment do
    Rake::Task["db:normalize_location"].invoke
  end

  desc "Merge duplicate artists (case-insensitive). CRISTOPH and Cristoph become one."
  task normalize_artists: :environment do
    groups = Artist.all.group_by { |a| a.name.to_s.downcase.strip }
    updated = 0

    groups.each do |normalized_key, artist_list|
      next if artist_list.size <= 1

      # Keep the first, merge others into it. Use titleize for canonical name.
      canonical_artist = artist_list.first
      canonical_name = normalized_key.titleize
      duplicates = artist_list[1..]
      canonical_event_ids = canonical_artist.artist_events.pluck(:event_id).to_set

      duplicates.each do |dup|
        dup.artist_events.find_each do |ae|
          next if ae.artist_id == canonical_artist.id
          next if canonical_event_ids.include?(ae.event_id)

          ae.update!(artist_id: canonical_artist.id)
          canonical_event_ids.add(ae.event_id)
        end
        dup.artist_events.destroy_all
        dup.destroy
        updated += 1
        puts "  Merged '#{dup.name}' -> '#{canonical_name}'"
      end

      # Update canonical artist's name to titleized if different
      if canonical_artist.name != canonical_name
        old_name = canonical_artist.name
        canonical_artist.update_column(:name, canonical_name)
        puts "  Renamed '#{old_name}' -> '#{canonical_name}'"
      end
    end

    %w[movement mmw].each { |city| Rails.cache.delete("events-v1:#{city}") }
    puts "Normalized artists: #{updated} duplicates merged"
  end

  desc "List all genre names in the database (to find exact names for merge)"
  task list_genres: :environment do
    genres = Genre.order(:name).pluck(:name, :id)
    puts "Genres in database (#{genres.size} total):"
    genres.each { |name, id| puts "  #{id}: #{name.inspect}" }
  end

  desc "Merge one genre into another. Usage: rake db:merge_genres FROM=UKG INTO=Garage"
  task merge_genres: :environment do
    from_name = ENV["FROM"]
    into_name = ENV["INTO"]

    if from_name.blank? || into_name.blank?
      puts "Usage: rake db:merge_genres FROM=UKG INTO=Garage"
      puts "Run 'rake db:list_genres' to see exact genre names"
      exit 1
    end

    # Case-insensitive find
    from_genre = Genre.where("LOWER(TRIM(name)) = ?", from_name.to_s.downcase.strip).first
    into_genre = Genre.where("LOWER(TRIM(name)) = ?", into_name.to_s.downcase.strip).first

    unless from_genre
      puts "Genre '#{from_name}' not found. Run 'rake db:list_genres' to see available genres"
      exit 1
    end

    unless into_genre
      puts "Genre '#{into_name}' not found. Run 'rake db:list_genres' to see available genres"
      exit 1
    end

    if from_genre.id == into_genre.id
      puts "FROM and INTO are the same genre (#{from_genre.name})"
      exit 1
    end

    events_with_from = Event.joins(:genres).where(genres: { id: from_genre.id }).distinct
    count = 0

    from_name_actual = from_genre.name
    into_name_actual = into_genre.name

    events_with_from.find_each do |event|
      event.genres.delete(from_genre)
      event.genres << into_genre unless event.genres.include?(into_genre)
      count += 1
    end

    from_genre.destroy
    %w[movement mmw].each { |city| Rails.cache.delete("events-v1:#{city}") }

    puts "Merged '#{from_name_actual}' into '#{into_name_actual}': #{count} events updated"
  end
end
