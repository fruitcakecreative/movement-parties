class ChangeStatusToIntegerInUserEvents < ActiveRecord::Migration[7.0]
  def change
    change_column :user_events, :status, :integer, using: 'status::integer'
  end
end
