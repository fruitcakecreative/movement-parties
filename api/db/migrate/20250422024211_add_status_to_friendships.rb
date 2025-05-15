class AddStatusToFriendships < ActiveRecord::Migration[7.2]
  def change
    add_column :friendships, :status, :string
  end
end
