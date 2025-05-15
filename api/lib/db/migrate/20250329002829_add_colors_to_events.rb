class AddColorsToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :bg_color, :string
  end
end
