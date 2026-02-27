class AddCascadeDeletesToArtistEvents < ActiveRecord::Migration[7.1]
  def change
    # artist_events -> events
    remove_foreign_key :artist_events, :events
    add_foreign_key :artist_events, :events, on_delete: :cascade

    # artist_events -> artists
    remove_foreign_key :artist_events, :artists
    add_foreign_key :artist_events, :artists, on_delete: :cascade

    # user_events -> events
    remove_foreign_key :user_events, :events
    add_foreign_key :user_events, :events, on_delete: :cascade

    # user_events -> users (optional but recommended)
    remove_foreign_key :user_events, :users
    add_foreign_key :user_events, :users, on_delete: :cascade
  end
end
