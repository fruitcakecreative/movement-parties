# frozen_string_literal: true

# Shared venue matching, title matching, and event-finding logic for all import tasks.
# Prevents false venue matches (e.g. Boho House vs Scotty Boy Presents: Deep House Brunch)
# and requires strict title match for multi-space venues (e.g. Clevelander main + rooftop).
module ImportHelpers
  # Words that are too generic to prove two venue *names* are the same (never match on these alone).
  # Includes wynwood — many unrelated venues contain it; nightclub/river/park/island/casino caused
  # false positives (M2 vs LIV, Mad Radio vs Triangle, Watson Island vs Hialeah Park Casino).
  VENUE_MATCH_STOP_WORDS = %w[
    hotel rooftop terrace lounge bar club room beach miami sound the level ground space
    south wynwood downtown tba studios house brunch presents deep boy
    center convention arena stadium hall
    nightclub river park island casino warehouse
  ].freeze

  TITLE_FILLER = %w[miami music week present presents 2026 mmw open air open-air].freeze

  # Stripped when comparing EDM Train titles to existing events (venue + date match).
  EDM_IMPORT_TITLE_STOP_WORDS = %w[
    miami music week mmw wmc wmc2026
    2024 2025 2026 2027 2028
    present presents presented presenting
    official
    tickets ticket
    south beach florida fl usa
    the a an at in on for of to
    and or
    open air openair
    rooftop party spring break night
  ].freeze

  MMW_TZ = ActiveSupport::TimeZone["America/New_York"].freeze

  STRICT_TITLE_VENUE_PATTERNS = %w[clevelander].freeze

  # EDM Train venue names -> our DB venue names (prevents overwriting Clevelander etc.)
  # "m2 nightclub" otherwise fuzzy-matches any other * Nightclub (e.g. LIV) on the word nightclub alone.
  EDM_TRAIN_VENUE_MAP = {
    "clevelander" => "Clevelander South Beach",
    "clevelander rooftop" => "C-Level Rooftop Terrace (at Clevelander South Beach)",
    "m2 nightclub" => "M2 Miami",
    "m2" => "M2 Miami",
    # "Miami (Warehouse)" normalizes to "warehouse" after stripping miami — map to real venue name
    "warehouse" => "Secret Warehouse"
  }.freeze

  GISELLE_ROOFTOP_VENUE_NAME = "Giselle Rooftop (at E11EVEN)".freeze

  class << self
    # Esmé -> Esme, Obskür -> Obskur (used before stripping non-ASCII)
    def fold_accents(str)
      I18n.transliterate(str.to_s)
    rescue StandardError
      str.to_s
    end

    def normalize_text(value)
      fold_accents(value.to_s)
        .downcase
        .gsub("&", " and ")
        .gsub(/[^a-z0-9\s]/, " ")
        .gsub(/\s+/, " ")
        .strip
    end

    def normalize_venue_name(name)
      normalize_text(name)
        .gsub(/\bthe\b/, "")
        .gsub(/\bclub\b/, "")
        .gsub(/\bmiami\b/, "")
        .gsub(/\bsound\b/, "")
        .gsub(/\broom\b/, "")
        .gsub(/\s+/, " ")
        .strip
    end

    # Whole-word match: require distinctive words (exclude generic terms).
    # Returns true if existing and incoming venue names refer to the same venue.
    def venue_match?(existing_venue_name, incoming_venue_name)
      existing = normalize_venue_name(existing_venue_name)
      incoming = normalize_venue_name(incoming_venue_name)
      return true if existing == incoming
      return false if existing.blank? || incoming.blank?

      significant = lambda do |w|
        w = w.to_s.strip
        w.length >= 4 && !VENUE_MATCH_STOP_WORDS.include?(w)
      end
      incoming_words = incoming.split(/\s+/).select(&significant).to_set
      existing_words = existing.split(/\s+/).select(&significant).to_set
      return false if incoming_words.empty? || existing_words.empty?

      shared = incoming_words & existing_words
      return false if shared.empty?

      # Avoid "one generic leftover" collisions (e.g. only "triangle" or "radio" after stops —
      # still require 2+ shared tokens when both names have 2+ candidates).
      smaller = [incoming_words.size, existing_words.size].min
      return shared.size >= 2 if smaller >= 2

      shared.any?
    end

    # EDM import: we already resolved a Venue row (address + name, etc.). Prefer matching
    # event.venue_id to that row instead of venue_match? on strings — "LIV Miami" vs "LIV Nightclub Miami"
    # often yields no overlapping significant tokens (liv is 3 chars, nightclub is a stop word), so fuzzy
    # name matching fails even though both rows are the same place.
    def edm_import_venue_matches_event?(event, resolved_venue:, edm_venue_name:)
      return false unless event

      if resolved_venue.respond_to?(:id) && resolved_venue.id.present? && event.venue_id == resolved_venue.id
        return true
      end

      venue_match?(event.venue&.name, edm_venue_name)
    end

    # Fuzzy title match: returns true if titles are likely the same event.
    def title_words_match?(incoming, existing)
      return true if incoming.to_s.strip.downcase == existing.to_s.strip.downcase
      return false if incoming.blank? || existing.blank?

      wa = words_from_title(incoming)
      wb = words_from_title(existing)
      return true if (wa & wb).size >= 1
      return true if similar_words?(wa, wb)

      short, long = [incoming.to_s, existing.to_s].sort_by(&:length)
      short.length >= 6 && long.downcase.include?(short.downcase)
    end

    # For venues with multiple spaces (main + rooftop), require exact title match.
    def venue_requires_strict_title?(venue)
      return false unless venue

      name = venue.respond_to?(:name) ? venue.name : venue.to_s
      name = name.to_s.downcase
      STRICT_TITLE_VENUE_PATTERNS.any? { |p| name.include?(p) }
    end

    # Normalized title for EDM import matching (same event, different wording).
    def edm_import_title_signature(title)
      s = fold_accents(title.to_s)
      s = s.gsub(/\([^)]*\)/, " ") # (03/29), (MM/DD)
      s = s.gsub(/\bspring\s+break\s*:\s*/i, " ")
           .gsub(/\bspring\s+break\b/i, " ")
      s = s.gsub(/\bmmw\s+20\d{2}\s*-\s*/i, " ")
           .gsub(/\bmiami\s+music\s+week\s+/i, " ")
      s = s.downcase
           .gsub(/\bblack\s+hole\b/i, "blackhole")
           .gsub("&", " and ")
           .gsub(/[^a-z0-9\s]/, " ")
           .gsub(/\s+/, " ")
           .strip
      s.split
       .reject { |w| w.length < 2 || EDM_IMPORT_TITLE_STOP_WORDS.include?(w) }
       .join(" ")
    end

    def edm_import_titles_equivalent?(a, b)
      sa = edm_import_title_signature(a)
      sb = edm_import_title_signature(b)
      return false if sa.blank? || sb.blank?

      return true if sa == sb

      # One title extends the other (e.g. short listing vs longer marketing title)
      shorter, longer = [sa, sb].minmax_by(&:length)
      longer.start_with?("#{shorter} ")
    end

    # When marketing prefixes differ (SPRING BREAK :, MMW 2026 -) but core words overlap
    def edm_import_titles_loosely_equivalent?(a, b)
      return true if edm_import_titles_equivalent?(a, b)

      wa = edm_import_title_signature(a).split
      wb = edm_import_title_signature(b).split
      return false if wa.empty? || wb.empty?

      sa = wa.to_set
      sb = wb.to_set
      inter = sa & sb
      shorter_size = [sa.size, sb.size].min
      return true if shorter_size.positive? && (inter.size * 2) >= shorter_size
      return true if inter.size >= 2 && inter.size >= shorter_size - 1

      false
    end

    # Incoming JSON artist names appear as substring in existing event title (Kazbah showcase, etc.)
    def edm_import_artist_mentioned_in_title?(event_title, incoming_artists)
      t = fold_accents(event_title.to_s).downcase
      Array(incoming_artists).each do |a|
        name = a["name"].to_s.strip
        next if name.length < 4

        n = fold_accents(name).downcase
        return true if t.include?(n)

        n.split.each do |part|
          next if part.length < 5

          return true if t.include?(part)
        end
      end
      false
    end

    # Distinctive tokens from edmtrain.com/.../slug-12345 (kazbah, coldharbour, …)
    EDM_URL_SLUG_STOP = %w[
      miami fl edmtrain music week showcase event tickets live
    ].freeze

    def edm_import_url_slug_keywords(url)
      base = url.to_s.strip.sub(/\?.*\z/, "")
      path = base.sub(%r{\Ahttps?://[^/]+}i, "")
      slug = path.to_s.split("/").last.to_s.sub(/-\d+\z/, "")
      slug.split("-").map { |w| fold_accents(w).downcase }
          .reject { |w| w.length < 4 || EDM_URL_SLUG_STOP.include?(w) }
    end

    def edm_import_slug_matches_title?(keywords, event_title)
      return false if keywords.blank?

      t = fold_accents(event_title.to_s).downcase
      keywords.any? { |k| k.length >= 5 && t.include?(k) }
    end

    # Street-style venue names from EDM Train (prefer address DB lookup over fuzzy name)
    def edm_import_venue_name_looks_like_address?(name)
      n = name.to_s.strip
      n.match?(/\A\d{1,5}\s/) || n.match?(/\b(nw|ne|sw|se)\b/i) || n.match?(/\b(st|street|ave|avenue)\b/i)
    end

    # UTC range that covers one calendar day in Miami (for querying events.start_time)
    def mmw_local_date_to_utc_range(local_date)
      d = local_date.is_a?(Date) ? local_date : local_date.to_date
      start_t = MMW_TZ.local(d.year, d.month, d.day, 0, 0, 0)
      start_t..start_t.end_of_day
    end

    # EDM Train date-only rows use local midnight; matching by clock time vs 19hz/real times fails unless we treat these as "any time that day".
    def event_start_time_is_local_midnight_placeholder?(event, tz = MMW_TZ)
      return false unless event&.start_time

      t = event.start_time.in_time_zone(tz)
      t.hour.zero? && t.min.zero? && t.sec.zero?
    end

    # Normalize street addresses for fuzzy equality (zip, st/street, NW vs Northwest, etc.)
    def address_match_signature(addr)
      s = fold_accents(addr.to_s).downcase
      s = s.gsub(/\bnorthwest\b/i, "nw")
           .gsub(/\bnortheast\b/i, "ne")
           .gsub(/\bsouthwest\b/i, "sw")
           .gsub(/\bsoutheast\b/i, "se")
      s = s.gsub(/[^a-z0-9\s]/, " ")
      s = s.gsub(/\b(\d+)(st|nd|rd|th)\b/i, '\1')
      s = s.gsub(/\bstreet\b/, "st")
           .gsub(/\bavenue\b/, "ave")
           .gsub(/\broad\b/, "rd")
           .gsub(/\bdrive\b/, "dr")
           .gsub(/\bboulevard\b/, "blvd")
      s = s.gsub(/\s+/, " ").strip
      s = s.gsub(/\b(fl|florida|usa|united states)\b/, "").gsub(/\s+/, " ").strip
      # ZIP / +4 so "… miami 33138" matches "… miami"
      s = s.gsub(/\b\d{5}(?:-\d{4})?\b/, "").gsub(/\s+/, " ").strip
      # EDM Train often sends "Blvd FL 3312" (typo for 33127); stripping "fl" leaves a stray 4-digit
      # fragment between street type and city — drop it so we still match DB "… Blvd, Miami 33127".
      s = s.gsub(
        /\b(blvd|st|ave|dr|rd|ln|cir|ct|pl|way|pkwy|broadway)\s+\d{4}\s+(miami|ft|fort|lauderdale|hollywood|hialeah|doral|coral)\b/i,
        '\1 \2'
      )
      s.gsub(/\s+/, " ").strip
    end

    def venue_addresses_equivalent?(a, b)
      return false if a.blank? || b.blank?

      address_match_signature(a) == address_match_signature(b)
    end

    # All venues in city whose address normalizes equal to the given one (may be several rooms at one address).
    def find_venues_by_address(city:, address:)
      return [] if address.blank?

      sig = address_match_signature(address)
      return [] if sig.length < 8

      Venue.where(city_key: city).select do |v|
        v.address.present? && venue_addresses_equivalent?(v.address, address)
      end
    end

    # Back-compat: first row only (avoid for new code — use find_venues_by_address + disambiguation).
    def find_venue_by_address(city:, address:)
      find_venues_by_address(city: city, address: address).first
    end

    # Higher score = better match when several DB venues share one mailing address.
    def venue_disambiguation_score(db_venue_name, incoming_mapped_name)
      ex = normalize_venue_name(db_venue_name)
      inc = normalize_venue_name(incoming_mapped_name)
      return 10_000 if ex == inc

      return 5000 if inc.length >= 3 && ex.include?(inc)
      return 4500 if ex.length >= 3 && inc.include?(ex)

      significant = lambda do |w|
        w = w.to_s.strip
        w.length >= 4 && !VENUE_MATCH_STOP_WORDS.include?(w)
      end
      ew = ex.split(/\s+/).select(&significant).to_set
      iw = inc.split(/\s+/).select(&significant).to_set
      shared = ew & iw
      return 2000 + shared.size * 50 if shared.any?

      0
    end

    # Pick one venue when many share an address (MODE vs Club Space at same street, La Otra vs Mad Club, …).
    def pick_venue_among_shared_address(venues, mapped_venue_name)
      return nil if venues.blank?
      return venues.first if venues.size == 1

      scored = venues.map do |v|
        [venue_disambiguation_score(v.name, mapped_venue_name), v]
      end
      best_score = scored.map(&:first).max
      tied = scored.select { |s, _| s == best_score }.map(&:last)
      # Deterministic: prefer higher score already; ties → stable id
      tied.min_by(&:id)
    end

    # 1) If EDM gives an address: match all DB rows at that address, then disambiguate by EDM venue name.
    #    (Avoids picking the first DB row when Club Space / Floyd / The Ground share 34 NE 11th, etc.)
    # 2) Else fuzzy match by name city-wide (M2 vs LIV, …).
    def find_venue_for_edm_train(city:, mapped_venue_name:, raw_venue_name:, address:)
      if address.present?
        at_addr = find_venues_by_address(city: city, address: address)
        if at_addr.size == 1
          return [at_addr.first, :address]
        elsif at_addr.size > 1
          narrowed = at_addr.select { |v| venue_match?(v.name, mapped_venue_name) }
          if narrowed.any?
            chosen = narrowed.size == 1 ? narrowed.first : pick_venue_among_shared_address(narrowed, mapped_venue_name)
            return [chosen, :address_and_name]
          end
          # Same address but no fuzzy name hit (e.g. odd EDM label) — try city-wide name, not a random sibling.
        end
      end

      by_name = find_venue(city: city, venue_name: mapped_venue_name)
      return [by_name, :name] if by_name

      [nil, nil]
    end

    # EDM lists Giselle events under the main club; our DB uses a separate venue row for the rooftop.
    def edm_train_maybe_giselle_rooftop(city:, venue:, title:)
      return venue unless venue && title.to_s.match?(/giselle/i)

      return venue unless venue.name.to_s.strip.casecmp("E11EVEN MIAMI").zero?

      Venue.find_by(city_key: city, name: GISELLE_ROOFTOP_VENUE_NAME) || venue
    end

    # Map EDM Train venue names to our DB names (e.g. Clevelander -> Clevelander South Beach).
    def map_edm_train_venue_name(incoming_name)
      return incoming_name if incoming_name.blank?

      key = normalize_venue_name(incoming_name)
      EDM_TRAIN_VENUE_MAP[key] || incoming_name
    end

    # Find venue from DB by matching incoming venue name.
    def find_venue(city:, venue_name:)
      return nil if venue_name.blank?

      normalized_incoming = normalize_venue_name(venue_name)
      Venue.where(city_key: city).find do |v|
        existing = normalize_venue_name(v.name)
        venue_match?(existing, normalized_incoming)
      end
    end

    private

    def words_from_title(title)
      fold_accents(title.to_s).downcase.scan(/\b[a-z0-9]{3,}\b/).reject { |w| TITLE_FILLER.include?(w) }.to_set
    end

    def similar_words?(wa, wb)
      wa.any? do |w|
        wb.any? do |v|
          w.length >= 4 && v.length >= 4 && (w.start_with?(v[0, 4]) || v.start_with?(w[0, 4]))
        end
      end
    end
  end
end
