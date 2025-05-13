class AddManualOverrideArtistsToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :manual_override_artists, :boolean
  end
end
