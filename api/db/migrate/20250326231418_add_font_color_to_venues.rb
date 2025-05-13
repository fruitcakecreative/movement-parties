class AddFontColorToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :font_color, :string
  end
end
