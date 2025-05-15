class AddTicketFieldsToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :ticket_price, :decimal, precision: 8, scale: 2
    add_column :events, :ticket_tier, :string
    add_column :events, :ticket_wave, :string
  end
end
