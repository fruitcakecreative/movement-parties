class AddProfileFieldsToArtists < ActiveRecord::Migration[7.2]
  def change
    add_column :artists, :city, :string
    add_column :artists, :genre_list, :text
    add_column :artists, :social, :text
    add_column :artists, :tags, :text
  end
end
