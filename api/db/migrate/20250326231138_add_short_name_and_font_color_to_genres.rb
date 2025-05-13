class AddShortNameAndFontColorToGenres < ActiveRecord::Migration[7.2]
  def change
    add_column :genres, :short_name, :string
    add_column :genres, :font_color, :string
  end
end
