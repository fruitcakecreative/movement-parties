class AddTicketUrlToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :ticket_url, :string
  end
end
