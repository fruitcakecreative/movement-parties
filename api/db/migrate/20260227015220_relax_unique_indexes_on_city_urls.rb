# db/migrate/xxxx_relax_unique_indexes_on_city_urls.rb
class RelaxUniqueIndexesOnCityUrls < ActiveRecord::Migration[7.0]
  def change
    remove_index :events, name: "index_events_on_city_key_and_event_url", if_exists: true
    add_index :events, [:city_key, :event_url], name: "index_events_on_city_key_and_event_url"

    remove_index :venues, name: "index_venues_on_city_key_and_venue_url", if_exists: true
    add_index :venues, [:city_key, :venue_url], name: "index_venues_on_city_key_and_venue_url"
  end
end
