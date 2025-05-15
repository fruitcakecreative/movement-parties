class AddFieldsToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :venue_type, :string
    add_column :venues, :serves_alcohol, :string
    add_column :venues, :notes, :text
  end
end
