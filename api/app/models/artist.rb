class Artist < ApplicationRecord
  belongs_to :genre, optional: true
  validates :name, presence: true
  has_many :artist_events, dependent: :destroy
  has_many :events, through: :artist_events
  # genre validation removed or made optional

  # Case-insensitive find or create (CRISTOPH and Cristoph -> same artist)
  def self.find_or_create_by_canonical_name!(name)
    return nil if name.blank?

    found = where("LOWER(TRIM(name)) = ?", name.to_s.strip.downcase).first
    found || create!(name: name.to_s.strip)
  end
end
