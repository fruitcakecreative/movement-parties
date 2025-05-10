class AddHexColorToGenres < ActiveRecord::Migration[7.2]
  def change
    add_column :genres, :hex_color, :string
  end
end
