class AddImageFilenameToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :image_filename, :string
  end
end
