class Artist < ApplicationRecord
  belongs_to :genre, optional: true
  validates :name, presence: true
  has_many :artist_events
  has_many :events, through: :artist_events
  # genre validation removed or made optional
end
