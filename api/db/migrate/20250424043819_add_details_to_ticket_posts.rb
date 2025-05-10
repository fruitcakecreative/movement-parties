class AddDetailsToTicketPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :ticket_posts, :price, :string unless column_exists?(:ticket_posts, :price)
    add_column :ticket_posts, :looking_for, :string unless column_exists?(:ticket_posts, :looking_for)
    add_column :ticket_posts, :note, :text unless column_exists?(:ticket_posts, :note)
  end
end
