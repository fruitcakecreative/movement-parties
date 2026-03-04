class Venue < ApplicationRecord
  has_many :events
  has_one_attached :logo

  scope :movement, -> { where(city_key: "movement") }
  scope :mmw,      -> { where(city_key: "mmw") }

  BASE_VENUE_TYPE_STYLES = {
    "Restaurant/Bar/Lounge"     => { bg: "#EF4444", font: "#FFFFFF" }, # red
    "Small Intimate Venue"      => { bg: "#F97316", font: "#111827" }, # orange
    "Pool"                      => { bg: "#FFEB3B", font: "#111827" }, # yellow
    "Music Venue/Event Space"   => { bg: "#22C55E", font: "#052E16" }, # green
    "Boat"                      => { bg: "#3B82F6", font: "#FFFFFF" }, # blue
    "Nightclub/Club"            => { bg: "#7C3AED", font: "#FFFFFF" }, # purple
    "Rooftop"                   => { bg: "#EC4899", font: "#FFFFFF" }, # pink
    "Other"                     => { bg: "#6B7280", font: "#FFFFFF" }  # grey
  }.freeze

  rails_admin do
    list do
      scopes [:movement, :mmw]
    end
  end

  before_validation :default_city_key, on: :create
  before_validation :apply_type_colors

  def default_city_key
    self.city_key ||= (Current.city_key.presence || "movement")
  end

  def type_style
    VENUE_TYPE_STYLES[venue_type] || VENUE_TYPE_STYLES["Other"]
  end

  def apply_type_colors
    return unless city_key == "mmw" # only MMW
    self.bg_color   = type_style[:bg]
    self.font_color = type_style[:font]
  end

  def logo_url
    return nil unless logo.attached?

    Aws::S3::Object.new(
      bucket_name: ::ENV.fetch("AWS_BUCKET"),
      key: logo.blob.key,
      client: Aws::S3::Client.new
    ).public_url
  end
  require "zlib"

  before_validation :apply_type_colors

  def apply_type_colors
    return unless city_key == "mmw"
    base = BASE_VENUE_TYPE_STYLES[venue_type] || BASE_VENUE_TYPE_STYLES["Other"]

    self.bg_color   = shade_hex(base[:bg], shade_seed)
    self.font_color = base[:font]
  end

  def shade_seed
    # stable per-venue; name changes will change shade (ok) — use id if you prefer once present
    Zlib.crc32((id || name || "venue").to_s)
  end

  def shade_hex(hex, seed)
    # create a lighter/darker shade by adjusting brightness 0.80..1.10
    factor = 0.80 + ((seed % 31) / 100.0) # 0.80..1.10
    r, g, b = hex.delete("#").scan(/../).map { |c| c.to_i(16) }
    r = [[(r * factor).round, 0].max, 255].min
    g = [[(g * factor).round, 0].max, 255].min
    b = [[(b * factor).round, 0].max, 255].min
    format("#%02X%02X%02X", r, g, b)
  end
  private :shade_seed, :shade_hex
end
