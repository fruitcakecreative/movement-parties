class CreateJoinTableEventsGenres < ActiveRecord::Migration[7.0]
  def change
    create_join_table :events, :genres do |t|
      t.index :event_id
      t.index :genre_id
    end
  end
end
