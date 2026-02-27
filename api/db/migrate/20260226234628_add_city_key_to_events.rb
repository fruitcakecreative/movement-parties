class AddCityKeyToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :city_key, :string
  end
end
