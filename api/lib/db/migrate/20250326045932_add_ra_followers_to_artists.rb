class AddRaFollowersToArtists < ActiveRecord::Migration[7.2]
  def change
    add_column :artists, :ra_followers, :integer
  end
end
