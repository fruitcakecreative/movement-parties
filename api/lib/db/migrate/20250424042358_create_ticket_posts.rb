class CreateTicketPosts < ActiveRecord::Migration[7.2]
  def change
    unless table_exists?(:ticket_posts)
      create_table :ticket_posts do |t|
        t.references :user, null: false, foreign_key: true
        t.string :post_type
        t.string :event_name
        t.string :contact_info

        t.timestamps
      end
    end
  end
end
