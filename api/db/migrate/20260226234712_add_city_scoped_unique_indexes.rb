class AddCityScopedUniqueIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :events,  [:city_key, :event_url], unique: true
    add_index :venues,  [:city_key, :venue_url], unique: true
  end
end
