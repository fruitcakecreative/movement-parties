# frozen_string_literal: true

require_relative "../merge_event_pair"

namespace :db do
  desc "Backfill source URL columns from event_url for existing events"
  task backfill_source_urls: :environment do
    updated = 0

    Event.where.not(event_url: [nil, ""]).find_each do |event|
      url = event.event_url.to_s.strip
      next if url.blank?

      changes = {}

      if url.include?("ra.co") && event.ra_url.blank?
        changes[:ra_url] = url
      end
      if url.include?("shotgun.live") && event.shotgun_url.blank?
        changes[:shotgun_url] = url
      end
      if url.include?("dice.fm") && event.dice_url.blank?
        changes[:dice_url] = url
      end
      if url.include?("posh.vip") && event.posh_url.blank?
        changes[:posh_url] = url
      end
      if url.include?("tixr.com") && event.tixr_url.blank?
        changes[:tixr_url] = url
      end
      if url.include?("edmtrain.com") && event.edm_train_url.blank?
        changes[:edm_train_url] = url
      end

      next if changes.empty?

      event.update_columns(changes)
      updated += 1
      puts "  #{event.id}: #{event.title} - backfilled #{changes.keys.join(', ')}"
    end

    %w[movement mmw].each { |city| Rails.cache.delete("events-v1:#{city}") }
    puts "Backfilled source URLs for #{updated} events"
  end

  desc "Merge duplicate events that share a source URL (ra_url, dice_url, etc). Safe: no venue+time guessing."
  task merge_duplicate_events: :environment do
    city_key = ENV["CITY"] || "mmw"
    dry_run = ENV["DRY_RUN"] == "1"

    puts "Finding duplicate events in #{city_key} by shared source URLs (dry_run=#{dry_run})..."

    events = Event.where(city_key: city_key).includes(:venue, :genres, :artists).to_a

    # Build url -> event_ids map, then union-find to group events that share any URL
    url_to_events = Hash.new { |h, k| h[k] = [] }
    events.each do |e|
      Event::SOURCE_URL_COLUMNS.each do |col|
        url = e.send(col).to_s.strip
        url_to_events[url] << e.id if url.present?
      end
    end

    # Union-find: events sharing a URL belong to same group
    parent = events.map { |e| [e.id, e.id] }.to_h
    find_root = lambda do |id|
      parent[id] = find_root.call(parent[id]) if parent[id] != id
      parent[id]
    end
    union_ids = lambda do |a, b|
      pa = find_root.call(a)
      pb = find_root.call(b)
      parent[pa] = pb
    end

    # Don't merge multi-day festivals: "Ultra Day 1" vs "Ultra Day 2" should stay separate
    different_day = lambda do |a, b|
      day_a = a.title.to_s.match(/Day\s*(\d+)/i)&.[](1)
      day_b = b.title.to_s.match(/Day\s*(\d+)/i)&.[](1)
      day_a.present? && day_b.present? && day_a != day_b
    end

    event_by_id = events.index_by(&:id)
    url_to_events.each_value do |ids|
      ids.uniq.map { |id| event_by_id[id] }.compact.each_cons(2) do |a, b|
        next if different_day.call(a, b)
        union_ids.call(a.id, b.id)
      end
    end

    groups = events.group_by { |e| find_root.call(e.id) }
    duplicates = groups.select { |_root, list| list.size > 1 }
    puts "Found #{duplicates.size} URL-linked groups (#{duplicates.sum { |_, l| l.size - 1 }} events to merge)"

    merged_count = 0

    duplicates.each do |_root, list|
      # Pick keeper: prefer RA, then most source URLs, then prefer longer title, then oldest
      keeper = list.max_by do |e|
        score = 0
        score += 100 if e.ra_url.present?
        score += 50 if e.event_url.present?
        score += 10 if e.dice_url.present?
        score += 10 if e.shotgun_url.present?
        score += 10 if e.posh_url.present?
        score += 10 if e.tixr_url.present?
        score += 10 if e.edm_train_url.present?
        [score, (e.title.to_s.length), -e.id]
      end

      to_merge = list - [keeper]

      to_merge.each do |dup|
        shared = Event::SOURCE_URL_COLUMNS.select { |c| v = dup.send(c); v.present? && keeper.send(c) == v }
        puts "  Merge: #{dup.title} (#{dup.id}) -> #{keeper.title} (#{keeper.id}) [shared: #{shared.join(', ')}]"

        next if dry_run

        MergeEventPair.merge_duplicate_into_keeper!(keeper, dup)
        merged_count += 1
      end
    end

    MergeEventPair.clear_event_caches
    puts "Merged #{merged_count} duplicate events" unless dry_run
    puts "Dry run complete. Run without DRY_RUN=1 to apply." if dry_run
  end

  desc "Fuzzy merge: same venue_id + start_time + (title overlap OR artist overlap). DRY_RUN by default - use APPLY=1 to run."
  task merge_duplicate_events_fuzzy: :environment do
    city_key = ENV["CITY"] || "mmw"
    dry_run = ENV["APPLY"] != "1"

    puts "Finding fuzzy duplicate candidates in #{city_key} (venue+time+title/artists)..."
    puts "DRY RUN - review output, then run with APPLY=1 to merge" if dry_run

    events = Event.where(city_key: city_key).includes(:venue, :genres, :artists).to_a

    # Skip events that share any URL with another (handled by URL merge)
    url_to_ids = Hash.new { |h, k| h[k] = [] }
    events.each do |e|
      Event::SOURCE_URL_COLUMNS.each do |col|
        url = e.send(col).to_s.strip
        url_to_ids[url] << e.id if url.present?
      end
    end
    url_linked_ids = url_to_ids.values.select { |ids| ids.uniq.size > 1 }.flatten.uniq.to_set

    # Normalize title to words (3+ chars, exclude common filler)
    filler = %w[miami music week present 2026 mmw open air]
    words_from = lambda do |title|
      title.to_s.downcase.scan(/\b[a-z0-9]{3,}\b/).reject { |w| filler.include?(w) }.to_set
    end

    # Similar words: share 4+ char prefix (catches Noizu/Noize)
    similar_words = lambda do |wa, wb|
      wa.any? { |w| wb.any? { |v| w.length >= 4 && v.length >= 4 && (w.start_with?(v[0, 4]) || v.start_with?(w[0, 4])) } }
    end

    # Match: title overlap >= 1, OR similar words, OR one title contains the other (6+ chars), OR 1+ shared artists
    should_merge = lambda do |a, b|
      return false if url_linked_ids.include?(a.id) && url_linked_ids.include?(b.id)
      wa = words_from.call(a.title)
      wb = words_from.call(b.title)
      return true if (wa & wb).size >= 1
      return true if similar_words.call(wa, wb)
      short, long = [a.title.to_s, b.title.to_s].sort_by(&:length)
      return true if short.length >= 6 && long.downcase.include?(short.downcase)
      (a.artist_ids & b.artist_ids).size >= 1
    end

    # Group by venue_id + date + hour
    groups = events.group_by do |e|
      next nil if e.venue_id.blank? || e.start_time.blank?
      [e.venue_id, e.start_time.to_date, e.start_time.hour]
    end.compact

    merge_one = lambda do |keeper, dup|
      puts "  Fuzzy: #{dup.title} (#{dup.id}) -> #{keeper.title} (#{keeper.id}) [venue: #{keeper.venue&.name}]"

      return if dry_run

      MergeEventPair.merge_duplicate_into_keeper!(keeper, dup)
    end

    pick_keeper = lambda do |list|
      list.max_by { |e| [e.ra_url.present? ? 1 : 0, e.title.to_s.length, -e.id] }
    end

    merged_count = 0
    candidates = groups.select { |_key, list| list.size > 1 }

    candidates.each do |(_venue_id, _date, _time), list|
      # Union-find: pair (a,b) in same cluster if should_merge
      parent = list.map { |e| [e.id, e.id] }.to_h
      find_root = lambda do |id|
        parent[id] = find_root.call(parent[id]) if parent[id] != id
        parent[id]
      end
      union_ids = lambda do |a, b|
        parent[find_root.call(a)] = find_root.call(b)
      end

      list.combination(2).each do |a, b|
        union_ids.call(a.id, b.id) if should_merge.call(a, b)
      end

      clusters = list.group_by { |e| find_root.call(e.id) }
      clusters.each do |_root, cluster|
        next if cluster.size < 2
        keeper = pick_keeper.call(cluster)
        to_merge = cluster - [keeper]
        to_merge.each do |dup|
          merge_one.call(keeper, dup)
          merged_count += 1 unless dry_run
        end
      end
    end

    MergeEventPair.clear_event_caches
    puts "Fuzzy merged #{merged_count} events" unless dry_run
    puts "Dry run done. Run with APPLY=1 to apply merges." if dry_run
  end

  desc "Merge two events by ID: KEEPER_ID survives, MERGE_ID is merged in and destroyed. Same city_key required. DRY_RUN=1 to preview."
  task merge_two_events: :environment do
    keeper_id = ENV["KEEPER_ID"].presence
    merge_id = ENV["MERGE_ID"].presence
    dry_run = ENV["DRY_RUN"] == "1"

    abort "Set KEEPER_ID (row to keep) and MERGE_ID (row to fold in and delete), e.g. KEEPER_ID=123 MERGE_ID=456" if keeper_id.blank? || merge_id.blank?
    abort "KEEPER_ID and MERGE_ID must differ" if keeper_id.to_i == merge_id.to_i

    keeper = Event.includes(:venue, :genres, :artists).find_by(id: keeper_id)
    merge = Event.includes(:venue, :genres, :artists).find_by(id: merge_id)
    abort "No event for KEEPER_ID=#{keeper_id.inspect}" unless keeper
    abort "No event for MERGE_ID=#{merge_id.inspect}" unless merge

    if keeper.city_key != merge.city_key
      abort "city_key must match (keeper=#{keeper.city_key.inspect} merge=#{merge.city_key.inspect})"
    end

    puts "Merge MERGE_ID=#{merge.id} (#{merge.title}) -> KEEPER_ID=#{keeper.id} (#{keeper.title}) [city=#{keeper.city_key}] dry_run=#{dry_run}"

    if dry_run
      puts "Dry run only. Run without DRY_RUN=1 to apply."
    else
      MergeEventPair.merge_duplicate_into_keeper!(keeper, merge)
      MergeEventPair.clear_event_caches
      puts "Done. Event #{merge_id} merged into #{keeper_id}."
    end
  end
end
