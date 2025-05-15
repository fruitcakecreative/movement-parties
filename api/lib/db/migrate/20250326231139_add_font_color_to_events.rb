class AddFontColorToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :font_color, :string
  end
end
