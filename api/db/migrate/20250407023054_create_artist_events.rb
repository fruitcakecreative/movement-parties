class CreateArtistEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :artist_events do |t|
      t.references :artist, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.datetime :set_start_time
      t.datetime :set_end_time
      t.boolean :live

      t.timestamps
    end
  end
end
