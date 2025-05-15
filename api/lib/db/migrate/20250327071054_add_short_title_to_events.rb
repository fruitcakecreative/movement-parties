class AddShortTitleToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :short_title, :string
  end
end
