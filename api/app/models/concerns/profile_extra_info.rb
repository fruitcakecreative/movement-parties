# Optional shareable profile fields (stored as JSON in users.profile_info).
module ProfileExtraInfo
  extend ActiveSupport::Concern

  PROFILE_EXTRA_KEYS = %w[
    weekends_attended
    hometown
    artist_excited
    favorite_venue
    movement_pro_tip
  ].freeze

  PROFILE_EXTRA_LIMITS = {
    "weekends_attended" => 40,
    "hometown" => 100,
    "artist_excited" => 100,
    "favorite_venue" => 40,
    "movement_pro_tip" => 300
  }.freeze

  def profile_extra_hash
    return {} if profile_info.blank?
    # Ignore legacy free-text bios (e.g. "Techno lover") stored before profile_extra JSON.
    return {} unless profile_info.strip.start_with?("{")

    parsed = JSON.parse(profile_info)
    return {} unless parsed.is_a?(Hash)

    PROFILE_EXTRA_KEYS.index_with do |key|
      parsed[key].to_s.strip.presence
    end.compact
  rescue JSON::ParserError
    {}
  end

  def profile_extra_filled?
    profile_extra_hash.any?
  end

  # Persists to users.profile_info as JSON. Merges with existing keys; empty string clears a field.
  def assign_profile_extra!(raw)
    incoming = raw.is_a?(ActionController::Parameters) ? raw.to_unsafe_h : raw.to_h
    incoming = incoming.stringify_keys
    merged = profile_extra_hash.stringify_keys

    PROFILE_EXTRA_KEYS.each do |key|
      unless incoming.key?(key)
        next
      end

      stripped = incoming[key].to_s.strip
      limit = PROFILE_EXTRA_LIMITS[key]
      stripped = stripped[0, limit] if limit && stripped.length > limit

      if stripped.present?
        merged[key] = stripped
      else
        merged.delete(key)
      end
    end

    self.profile_info = merged.presence&.to_json
  end
end
