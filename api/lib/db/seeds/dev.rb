# Clear existing data to avoid duplicates
ArtistEvent.destroy_all
EventAttendee.destroy_all
User.destroy_all
Event.destroy_all
Venue.destroy_all
Artist.destroy_all
Genre.destroy_all

# Create genres
house = Genre.create!(name: "House")
techno = Genre.create!(name: "Techno")
hiphop = Genre.create!(name: "Hip-Hop")

# Create venues
venue1 = Venue.create!(name: "Underground Club", location: "Detroit, MI", capacity: 500)
venue2 = Venue.create!(name: "Skyline Rooftop", location: "New York, NY", capacity: 300)

# Create artists
artist1 = Artist.create!(name: "DJ Shadow", genre: techno, description: "Techno legend")
artist2 = Artist.create!(name: "Carl Cox", genre: house, description: "King of House Music")
artist3 = Artist.create!(name: "Kendrick Lamar", genre: hiphop, description: "Hip-Hop master")

# Create events
event1 = Event.create!(
  title: "Techno Underground",
  date: "2025-05-30",
  start_time: "2025-05-30 22:00:00",
  end_time: "2025-05-31 04:00:00",
  venue: venue1,
  genres: [techno, house],
  description: "A night of pure underground techno vibes.",
  event_url: "https://ra.co/events/1",
  source: "RA",
  attending_count: 120
)

event2 = Event.create!(
  title: "House Music Festival",
  date: "2025-06-15",
  start_time: "2025-06-15 18:00:00",
  end_time: "2025-06-16 02:00:00",
  venue: venue2,
  genres: [house],
  description: "Experience the best in house music with top DJs.",
  event_url: "https://ra.co/events/2",
  source: "Manual",
  attending_count: 200
)

# Attach artists to events
event1.artists << artist1
event1.artists << artist2
event2.artists << artist2
event2.artists << artist3

# Create users
user1 = User.create!(name: "Alice", username: "alice", email: "alice@example.com", password: "password", profile_info: "Techno lover", admin: true)
user2 = User.create!(name: "Bob", username: "bob", email: "bob@example.com", password: "password", profile_info: "Hip-Hop enthusiast")

# Users attending events
EventAttendee.create!(user: user1, event: event1)
EventAttendee.create!(user: user2, event: event2)

puts "Seed data added!"
