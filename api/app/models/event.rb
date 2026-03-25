class Event < ApplicationRecord
  SOURCE_URL_COLUMNS = %w[event_url ticket_url ra_url dice_url shotgun_url posh_url tixr_url edm_train_url].freeze

  belongs_to :venue
  has_and_belongs_to_many :genres
  has_many :event_attendees
  has_many :users, through: :event_attendees
  has_many :artist_events, dependent: :destroy
  has_many :artists, through: :artist_events
  has_many :user_events, class_name: 'UserEvent', dependent: :destroy
  has_many :users, through: :user_events
  has_many :ticket_posts
  has_one_attached :logo

  scope :movement, -> { where(city_key: "movement") }
  scope :mmw,      -> { where(city_key: "mmw") }

  # Index / public lists: hide only after a short grace past end (or start if no end).
  GRACE_AFTER_SCHEDULE_END = 2.hours
  scope :not_past, lambda {
    where("COALESCE(events.end_time, events.start_time) > ?", GRACE_AFTER_SCHEDULE_END.ago)
  }

  rails_admin do
    list do
      scopes [:movement, :mmw]
    end
  end

  # Strip ?utm=… so we match stored URLs with or without query params
  def self.normalize_source_url(url)
    return nil if url.blank?

    url.to_s.strip.sub(/\?.*\z/, "")
  end

  # Find event by any source URL - prevents duplicates across imports
  def self.find_by_any_source_url(city_key, url)
    return nil if url.blank?

    stripped = url.to_s.strip
    needle = normalize_source_url(url)
    return nil if needle.blank?

    SOURCE_URL_COLUMNS.each do |col|
      found = where(city_key: city_key).where(
        "#{col} = ? OR #{col} = ? OR #{col} LIKE ?",
        stripped,
        needle,
        "#{needle}?%"
      ).first
      return found if found
    end

    nil
  end

  before_validation :default_city_key, on: :create
  def default_city_key
    self.city_key ||= (Current.city_key.presence || "movement")
  end

  def top_artists
    result = artists.sort_by { |a| -(a.ra_followers || 0) }.first(100).map do |artist|
      {
        id: artist.id,
        name: artist.name,
        ra_followers: artist.ra_followers
      }
    end
  end

  after_commit :process_manual_artist_names, if: -> { manual_artist_names.present? }

  def process_manual_artist_names
    names = manual_artist_names.split(",").map(&:strip).reject(&:blank?)
    names.each do |name|
      artist = Artist.find_or_create_by_canonical_name!(name)
      self.artists << artist if artist && !self.artist_ids.include?(artist.id)
    end
    update_column(:manual_artist_names, nil)
  end


  # Convert start_time to Planby-compatible format (remove 'Z')
  def formatted_start_time
    start_time&.strftime("%Y-%m-%dT%H:%M:%S") # Removes 'Z'
  end

  # Convert end_time to Planby-compatible format (remove 'Z')
  def formatted_end_time
    end_time&.strftime("%Y-%m-%dT%H:%M:%S") # Removes 'Z'
  end

  before_validation :inherit_colors_from_venue

  def inherit_colors_from_venue
    return unless venue
    return unless city_key == "mmw" # only MMW (or venue.city_key == "mmw")
    self.bg_color   = venue.bg_color
    self.font_color = venue.font_color
  end
  private :inherit_colors_from_venue

end
