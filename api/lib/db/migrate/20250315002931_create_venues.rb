class CreateVenues < ActiveRecord::Migration[7.2]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :location
      t.integer :capacity

      t.timestamps
    end
  end
end
