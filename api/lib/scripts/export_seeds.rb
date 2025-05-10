require "json"

module Scripts
  class ExportSeeds
    def self.run
      EXPORT_PATH = Rails.root.join("db", "seeds", "staging_data")
      Dir.mkdir(EXPORT_PATH) unless Dir.exist?(EXPORT_PATH)

      [
        { model: Genre, file: "genres.json" },
        { model: Venue, file: "venues.json" },
        { model: Artist, file: "artists.json" },
        { model: Event, file: "events.json" },
        { model: EventAttendee, file: "event_attendees.json" }
      ].each do |entry|
        data = entry[:model].all.map(&:attributes)
        File.write(EXPORT_PATH.join(entry[:file]), JSON.pretty_generate(data))
        puts "Exported #{entry[:model]} (#{data.size} records)"
      end
    end
  end
end
