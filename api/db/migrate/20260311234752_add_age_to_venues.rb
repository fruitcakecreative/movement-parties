class AddAgeToVenues < ActiveRecord::Migration[7.0]
  def change
    add_column :venues, :age, :string
  end
end
