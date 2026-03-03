class Venue < ApplicationRecord
  has_many :events
  has_one_attached :logo

  scope :movement, -> { where(city_key: "movement") }
  scope :mmw,      -> { where(city_key: "mmw") }

  VENUE_TYPE_STYLES = {
    "Pool" => { bg: "#FFEB3B", font: "#111827" },  # bright yellow
    "Boat" => { bg: "#0284C7", font: "#FFFFFF" },  # sea blue
    "Rooftop Bar" => { bg: "#EC4899", font: "#FFFFFF" },     # pink
    "Outdoor Event/Festival Space" => { bg: "#86EFAC", font: "#052E16" }, # light green
    "Indoor Event Venue" => { bg: "#7C3AED", font: "#FFFFFF" },          # purple
    "Open-Air Venue" => { bg: "#38BDF8", font: "#082F49" },              # sky blue
    "Eclectic Indoor/Music Venue" => { bg: "#C026D3", font: "#FFFFFF" }, # magenta
    "Nightclub" => { bg: "#0F172A", font: "#FFFFFF" },                   # navy blue
    "Bar & Lounge" => { bg: "#7F1D1D", font: "#FFFFFF" },                # maroon
    "Restaurant/Bar" => { bg: "#F97316", font: "#111827" },              # orange
    "Warehouse" => { bg: "#6B7280", font: "#FFFFFF" },                   # grey
    "Other" => { bg: "#6B7280", font: "#FFFFFF" }
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
end
