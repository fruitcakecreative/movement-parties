# app/models/venue.rb
class Venue < ApplicationRecord
  require "zlib"

  has_many :events
  has_one_attached :logo

  scope :movement, -> { where(city_key: "movement") }
  scope :mmw,      -> { where(city_key: "mmw") }

  # Palettes (light -> dark)
  RED_SHADES = %w[
    #F2C1C3 #EBAEB0 #E18D91 #D87378 #D5575D #CF3B43 #C72C35 #A2242C #75191F
  ].freeze

  ORANGE_SHADES = %w[
    #F8D4B8 #F5C79E #F0AE79 #EA9B5C #E6873F #E06F1F #D25E14 #A94A10 #78340B #4C2006
  ].freeze

  YELLOW_SHADES = %w[
    #FFF3C4 #FFE682 #FFD433 #E6B300 #B88F00
  ].freeze

  GREEN_SHADES = %w[
    #E6F7ED
    #CFF2D9
    #B8EBC8
    #95DFAE
    #74D395
    #52C77B
    #2FBB60
    #1FA950
    #1A8640
    #12602E
    #0A3A1B
    #051F0F
  ].freeze

  BLUE_SHADES = %w[
    #C8E0F4 #8DBEE4 #4692CF #1969B1 #0D3A62 #071F33
  ].freeze

  PURPLE_SHADES = %w[
    #E2D4F3 #BB9EE4 #8C5ECE #642FB1 #4E248B #351760 #1F0C33
  ].freeze

  PINK_SHADES = %w[
    #EEC2D9 #DD9BBF #DF6C99 #D33171 #732046 #492033
  ].freeze

  GREY_SHADES = %w[
    #D1D5DB #A8AFB8 #767F8C #4B535F #2A2F37 #1B1F24
  ].freeze

  VENUE_TYPE_PALETTES = {
    "Restaurant/Bar/Lounge"     => RED_SHADES,
    "Small Intimate Venue"      => ORANGE_SHADES,
    "Pool"                      => YELLOW_SHADES,
    "Music Venue/Event Space"   => GREEN_SHADES,
    "Boat"                      => BLUE_SHADES,
    "Nightclub/Club"            => PURPLE_SHADES,
    "Rooftop"                   => PINK_SHADES,
    "Other"                     => GREY_SHADES
  }.freeze

  # Choose a readable font color per type
  LIGHT_TEXT_TYPES = %w[Nightclub/Club Rooftop Boat].freeze

  rails_admin do
    list do
      scopes [:movement, :mmw]
    end
  end

  before_validation :default_city_key, on: :create
  before_validation :normalize_location
  # before_validation :apply_type_colors

  def default_city_key
    self.city_key ||= (Current.city_key.presence || "movement")
  end

  def normalize_location
    return if location.blank?

    self.location = location.to_s.strip.titleize
  end

  def palette_for_type
    VENUE_TYPE_PALETTES[venue_type] || GREY_SHADES
  end

  def shade_seed
    Zlib.crc32((id || name || "venue").to_s)
  end

  def shade_index
    shade_seed % palette_for_type.length
  end

  def apply_type_colors
    return unless city_key == "mmw"

    self.bg_color = palette_for_type[shade_index]
    self.font_color =
      if %w[Pool Small\ Intimate\ Venue].include?(venue_type)
        "#111827" # dark text on bright colors
      else
        "#FFFFFF" # default light text
      end
  end
  private :palette_for_type, :shade_seed, :shade_index, :apply_type_colors

  def logo_url
    return nil unless logo.attached?

    Aws::S3::Object.new(
      bucket_name: ::ENV.fetch("AWS_BUCKET"),
      key: logo.blob.key,
      client: Aws::S3::Client.new
    ).public_url
  end
end
