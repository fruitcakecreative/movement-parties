class AddRaTicketMetadataToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :ra_ticket_status, :string
    add_column :events, :ra_ticket_on_sale_at, :datetime
    add_column :events, :ra_has_ticketing, :boolean, default: false, null: false
    add_column :events, :ra_is_free_ticketing, :boolean, default: false, null: false
  end
end
