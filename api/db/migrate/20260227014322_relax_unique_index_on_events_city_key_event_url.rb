class RelaxUniqueIndexOnEventsCityKeyEventUrl < ActiveRecord::Migration[7.0]
  def change
    remove_index :events, name: "index_events_on_city_key_and_event_url", if_exists: true
    add_index :events, [:city_key, :event_url], name: "index_events_on_city_key_and_event_url"
  end
end
