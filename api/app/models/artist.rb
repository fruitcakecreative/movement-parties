class Artist < ApplicationRecord
  belongs_to :genre, optional: true
  validates :name, presence: true
  has_many :artist_events, dependent: :destroy
  has_many :events, through: :artist_events
  # genre validation removed or made optional

  # Case-insensitive find or create; also folds accents (Obskür / Obskur, Esmé / Esme)
  def self.find_or_create_by_canonical_name!(name)
    return nil if name.blank?

    stripped = name.to_s.strip
    found = where("LOWER(TRIM(name)) = ?", stripped.downcase).first
    return found if found

    folded = ImportHelpers.fold_accents(stripped).downcase.gsub(/\s+/, " ").strip
    find_each do |artist|
      next if artist.name.blank?

      af = ImportHelpers.fold_accents(artist.name).downcase.gsub(/\s+/, " ").strip
      return artist if af == folded
    end

    create!(name: stripped)
  end
end
