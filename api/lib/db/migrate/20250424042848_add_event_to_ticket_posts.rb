class AddEventToTicketPosts < ActiveRecord::Migration[7.2]
  def change
    add_reference :ticket_posts, :event, null: false, foreign_key: true unless column_exists?(:ticket_posts, :event_id)
  end
end
