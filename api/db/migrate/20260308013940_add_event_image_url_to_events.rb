class AddEventImageUrlToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :event_image_url, :string
  end
end
