class AddHexColorToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :hex_color, :string
  end
end
