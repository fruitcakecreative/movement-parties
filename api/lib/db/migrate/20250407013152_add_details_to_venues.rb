class AddDetailsToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :venue_url, :string
    add_column :venues, :address, :string
    add_column :venues, :description, :text
    add_column :venues, :distance, :integer
    add_column :venues, :additional_images, :text
  end
end
