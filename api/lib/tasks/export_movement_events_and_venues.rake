# frozen_string_literal: true

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
  desc "CSV: Movement events (city_key = movement) — id, title, venue, description, age. FILE=path optional."
  task movement_events: :environment do
    headers = %w[id title venue description age]
    scope = Event.where(city_key: "movement").includes(:venue).order(:id)
    row = lambda do |e|
      [e.id, e.title, e.venue&.name, e.description, e.age]
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
