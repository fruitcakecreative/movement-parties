class AddSubheadingToVenues < ActiveRecord::Migration[7.2]
  def change
    add_column :venues, :subheading, :string
  end
end
