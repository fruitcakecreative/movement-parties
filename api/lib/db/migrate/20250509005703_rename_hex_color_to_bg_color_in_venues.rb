class RenameHexColorToBgColorInVenues < ActiveRecord::Migration[6.1]
  def change
    rename_column :venues, :hex_color, :bg_color
  end
end
