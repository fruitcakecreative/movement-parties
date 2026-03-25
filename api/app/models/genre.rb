class Genre < ApplicationRecord
  has_and_belongs_to_many :events
  has_many :artists

  # Alternate spellings / abbreviations → one stored genre name.
  # Keys MUST be lowercased; lookup is `GENRE_ALIASES[name.strip.downcase]`.
  # Do not use this for case-only variants ("afro house" vs "Afro House") — those
  # are merged by find_or_create (case-insensitive) + db:dedupe_genres_case.
  GENRE_ALIASES = {
    "ukg" => "Garage",
    "uk garage" => "Garage",
    "drum and bass" => "Drum & Bass",
    "drum & bass" => "Drum & Bass",
    "nu-disco" => "Nu Disco",
    "nu disco" => "Nu Disco",
    "hip-hop" => "Hip-Hop",
    "hip hop" => "Hip-Hop",
  }.freeze

  def self.canonical_name(name)
    raw = name.to_s.strip
    return raw if raw.blank?

    GENRE_ALIASES[raw.downcase] || raw
  end

  # Resolve existing row case-insensitively so "Deep House" and "deep house" share one Genre.
  def self.find_by_name_case_insensitive(name)
    base = name.to_s.strip
    return nil if base.blank?

    where("LOWER(TRIM(name)) = ?", base.downcase).first
  end

  def self.find_or_create_by_canonical_name!(name)
    cn = canonical_name(name)
    find_by_name_case_insensitive(cn) || create!(name: cn)
  end

  # Reassign events + artists from one genre to another, then delete `from_genre`.
  # Returns number of events that referenced `from_genre`.
  def self.merge_records!(from_genre, into_genre)
    raise ArgumentError, "from and into must differ" if from_genre.id == into_genre.id

    count = 0
    Event.joins(:genres).where(genres: { id: from_genre.id }).distinct.find_each do |event|
      event.genres.delete(from_genre)
      event.genres << into_genre unless event.genres.include?(into_genre)
      count += 1
    end

    Artist.where(genre_id: from_genre.id).update_all(genre_id: into_genre.id)
    from_genre.destroy!
    count
  end
end
