# frozen_string_literal: true

# Alternate spellings / import spellings for an Artist. Imports resolve via
# `normalized_key` before creating a duplicate row (see Artist.find_or_create_by_canonical_name!).
class ArtistAlias < ApplicationRecord
  belongs_to :artist

  validates :label, presence: true
  validates :normalized_key, presence: true, uniqueness: true

  before_validation :assign_normalized_key, on: :create

  # Remember a spelling (e.g. merged duplicate name) so future imports attach to `artist`.
  # No-op if it matches the artist's primary name key, or if another artist already owns the key.
  def self.record_for_artist!(artist, source_name)
    return if artist.blank?

    raw = source_name.to_s.strip
    return if raw.blank?

    key = Artist.normalize_import_name_key(raw)
    return if key.blank?

    primary_key = Artist.normalize_import_name_key(artist.name)
    return if key == primary_key

    existing = find_by(normalized_key: key)
    if existing
      return existing if existing.artist_id == artist.id

      Rails.logger.warn(
        "ArtistAlias: skip mapping #{raw.inspect} (key=#{key}) — already tied to artist_id=#{existing.artist_id}, not #{artist.id}"
      )
      return existing
    end

    create!(artist: artist, label: raw, normalized_key: key)
  rescue ActiveRecord::RecordNotUnique
    find_by(normalized_key: key)
  end

  private

  def assign_normalized_key
    self.normalized_key = Artist.normalize_import_name_key(label) if normalized_key.blank? && label.present?
  end
end
