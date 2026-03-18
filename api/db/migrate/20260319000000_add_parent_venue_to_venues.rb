# frozen_string_literal: true

class AddParentVenueToVenues < ActiveRecord::Migration[7.2]
  def change
    add_reference :venues, :parent_venue, foreign_key: { to_table: :venues }
  end
end
