# frozen_string_literal: true

require "csv"

namespace :export do
  desc "CSV: artists on Movement events (pronouns blank only; set ALL=1 for every Movement artist). Columns: id, name, pronouns, city, genre, genre_list, social, tags. FILE=path optional."
  task movement_artists: :environment do
    headers = %w[id name pronouns city genre genre_list social tags]

    scope =
      Artist
        .distinct
        .joins(:events)
        .where(events: { city_key: "movement" })
        .includes(:genre)
        .order(:id)

    unless ENV["ALL"].to_s == "1"
      # NULL, "", or whitespace-only
      scope = scope.where("TRIM(COALESCE(artists.pronouns, '')) = ''")
    end

    row = lambda do |a|
      [
        a.id,
        a.name,
        a.pronouns,
        a.city,
        a.genre&.name,
        a.genre_list,
        a.social,
        a.tags
      ]
    end

    count = 0
    path = ENV["FILE"].to_s.strip.presence

    if path
      CSV.open(path, "w:UTF-8") do |csv|
        csv << headers
        scope.find_each do |a|
          csv << row.call(a)
          count += 1
        end
      end
      puts "Exported #{count} artists to #{path}"
    else
      csv = CSV.new($stdout, encoding: "UTF-8")
      csv << headers
      scope.find_each do |a|
        csv << row.call(a)
        count += 1
      end
      warn "\nExported #{count} artists (stdout)" if count.positive?
    end
  end
end
