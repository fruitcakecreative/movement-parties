# frozen_string_literal: true

class AddSourceUrlsToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :ra_url, :string
    add_column :events, :shotgun_url, :string
    add_column :events, :posh_url, :string
    add_column :events, :tixr_url, :string

    add_index :events, :ra_url
    add_index :events, :shotgun_url
    add_index :events, :posh_url
    add_index :events, :tixr_url
  end
end
