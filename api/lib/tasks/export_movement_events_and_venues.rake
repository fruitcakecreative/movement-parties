# frozen_string_literal: true

# Example (paths in git): FILE=api/data/exports/movement_events.csv bin/rails export:movement_events
require "csv"

module MovementCsvExport
  module_function

  def write_csv(scope, headers, row_proc, label)
    count = 0
    path = ENV["FILE"].to_s.strip.presence

    if path
      CSV.open(path, "w:UTF-8") do |csv|
        csv << headers
        scope.find_each do |record|
          csv << row_proc.call(record)
          count += 1
        end
      end
      puts "Exported #{count} #{label} to #{path}"
    else
      csv = CSV.new($stdout, encoding: "UTF-8")
      csv << headers
      scope.find_each do |record|
        csv << row_proc.call(record)
        count += 1
      end
      warn "\nExported #{count} #{label} (stdout)" if count.positive?
    end
  end
end

namespace :export do
  desc "CSV: Movement events (city_key = movement) — full ticketing + metadata columns. FILE=path optional."
  task movement_events: :environment do
    headers = %w[
      id title description ticket_url ticket_price ticket_tier free_event food_available
      indoor_outdoor age promoter manual_artist_names event_image_url dice_url
    ]
    scope = Event.where(city_key: "movement").order(:id)
    row = lambda do |e|
      [
        e.id,
        e.title,
        e.description,
        e.ticket_url,
        e.ticket_price,
        e.ticket_tier,
        e.free_event,
        e.food_available,
        e.indoor_outdoor,
        e.age,
        e.promoter,
        e.manual_artist_names,
        e.event_image_url,
        e.dice_url
      ]
    end
    MovementCsvExport.write_csv(scope, headers, row, "events")
  end

  desc "CSV: Movement venues (city_key = movement) — id, name, location, venue_type, serves_alcohol, venue_url, address, description, age. FILE=path optional."
  task movement_venues: :environment do
    headers = %w[id name location venue_type serves_alcohol venue_url address description age]
    scope = Venue.where(city_key: "movement").order(:id)
    row = lambda do |v|
      [
        v.id,
        v.name,
        v.location,
        v.venue_type,
        v.serves_alcohol,
        v.venue_url,
        v.address,
        v.description,
        v.age
      ]
    end
    MovementCsvExport.write_csv(scope, headers, row, "venues")
  end
end
