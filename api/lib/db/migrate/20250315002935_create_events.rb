class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :date
      t.datetime :start_time
      t.datetime :end_time
      t.references :venue, null: false, foreign_key: true
      t.string :source
      t.references :genre, null: false, foreign_key: true
      t.text :description
      t.string :event_url
      t.integer :attending_count

      t.timestamps
    end
  end
end
