class CreateArtists < ActiveRecord::Migration[7.2]
  def change
    create_table :artists do |t|
      t.string :name
      t.references :genre, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
