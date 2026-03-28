class AddPronounsToArtists < ActiveRecord::Migration[7.2]
  def change
    add_column :artists, :pronouns, :string
  end
end
