class Genre < ApplicationRecord
  has_and_belongs_to_many :events
  has_many :artists

  # Map alternate names to canonical genre (e.g. UKG -> Garage)
  GENRE_ALIASES = {
    "UKG" => "Garage",
    "UK Garage" => "Garage",
  }.freeze

  def self.canonical_name(name)
    GENRE_ALIASES[name.to_s.strip] || name.to_s.strip
  end

  def self.find_or_create_by_canonical_name!(name)
    find_or_create_by!(name: canonical_name(name))
  end
end
