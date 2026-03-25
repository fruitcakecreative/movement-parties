# frozen_string_literal: true

module NormalizeDataRake
  def self.clear_events_caches
    %w[movement mmw].each do |city|
      %w[v1 v2 v4].each { |v| Rails.cache.delete("events-#{v}:#{city}") rescue nil }
    end
  end
end

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

    NormalizeDataRake.clear_events_caches
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

    NormalizeDataRake.clear_events_caches
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

    from_genre = Genre.find_by_name_case_insensitive(from_name)
    into_genre = Genre.find_by_name_case_insensitive(into_name)

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

    from_label = from_genre.name
    into_label = into_genre.name
    count = Genre.merge_records!(from_genre, into_genre)
    NormalizeDataRake.clear_events_caches

    puts "Merged '#{from_label}' into '#{into_label}': #{count} events updated"
  end

  desc "Merge genres that differ only by letter case (e.g. Afro House + afro house → afro house). " \
       "Prefers the all-lowercase spelling when present. DRY_RUN=1 to print only."
  task dedupe_genres_case: :environment do
    dry = ENV["DRY_RUN"].present?
    genres = Genre.all.to_a.reject { |g| g.name.blank? }
    groups = genres.group_by { |g| g.name.to_s.downcase.strip }
    merged_dupes = 0
    events_touched = 0

    groups.each do |_norm, list|
      next if list.size <= 1

      # Prefer a row whose name is already all-lowercase (e.g. "afro house"); else keep lowest id.
      keeper = list.find { |g| g.name == g.name.to_s.downcase }
      keeper ||= list.min_by(&:id)
      dups = list.reject { |g| g.id == keeper.id }

      dups.each do |dup|
        next if dry

        events_touched += Genre.merge_records!(dup, keeper)
        merged_dupes += 1
        puts "  Merged id=#{dup.id} '#{dup.name}' → id=#{keeper.id} '#{keeper.name}'"
      end

      next unless dry

      names = list.map { |g| "#{g.id}:#{g.name.inspect}" }.join(", ")
      puts "  [dry-run] would keep id=#{keeper.id} #{keeper.name.inspect}; others: #{names}"
    end

    if dry
      puts "dedupe_genres_case: dry run complete (no changes). Remove DRY_RUN=1 to apply."
    else
      NormalizeDataRake.clear_events_caches
      puts "dedupe_genres_case: merged #{merged_dupes} duplicate genre rows; #{events_touched} event reassignments (sum)"
    end
  end
end
