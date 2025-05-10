require "json"

# Wipe existing data
EventAttendee.delete_all
Event.delete_all
Venue.delete_all
Artist.delete_all
Genre.delete_all

puts "Seeding staging DB from JSON..."

[
  { model: Genre, file: "genres.json" },
  { model: Venue, file: "venues.json" },
  { model: Artist, file: "artists.json" },
  { model: Event, file: "events.json" },
  { model: EventAttendee, file: "event_attendees.json" }
].each do |entry|
  path = Rails.root.join("db", "seeds", "staging_data", entry[:file])
  next unless File.exist?(path)

  data = JSON.parse(File.read(path))
  entry[:model].insert_all!(data)
  puts "Seeded #{entry[:model]} (#{data.size} records)"
end

puts "Done seeding staging"
