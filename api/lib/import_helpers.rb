# frozen_string_literal: true

# Shared venue matching, title matching, and event-finding logic for all import tasks.
# Prevents false venue matches (e.g. Boho House vs Scotty Boy Presents: Deep House Brunch)
# and requires strict title match for multi-space venues (e.g. Clevelander main + rooftop).
module ImportHelpers
  VENUE_MATCH_STOP_WORDS = %w[
    hotel rooftop terrace lounge bar club room beach miami sound the level ground space
    south wynwood downtown tba studios house brunch presents deep boy
  ].freeze

  TITLE_FILLER = %w[miami music week present presents 2026 mmw open air open-air].freeze

  STRICT_TITLE_VENUE_PATTERNS = %w[clevelander].freeze

  class << self
    def normalize_text(value)
      value.to_s
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

      (incoming_words & existing_words).any?
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
      title.to_s.downcase.scan(/\b[a-z0-9]{3,}\b/).reject { |w| TITLE_FILLER.include?(w) }.to_set
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
