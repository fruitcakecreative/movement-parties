class AddCityKeyToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :city_key, :string
  end
end
