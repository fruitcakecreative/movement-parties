class AddManualArtistNamesToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :manual_artist_names, :text
  end
end
