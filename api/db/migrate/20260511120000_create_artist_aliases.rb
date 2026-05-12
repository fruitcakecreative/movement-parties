# frozen_string_literal: true

class CreateArtistAliases < ActiveRecord::Migration[7.2]
  def change
    create_table :artist_aliases do |t|
      t.references :artist, null: false, foreign_key: { on_delete: :cascade }
      t.string :label, null: false
      t.string :normalized_key, null: false
      t.timestamps
    end

    add_index :artist_aliases, :normalized_key, unique: true
    # artist_id index is already created by `t.references :artist` above
  end
end
