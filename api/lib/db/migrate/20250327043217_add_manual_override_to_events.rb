class AddManualOverrideToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :manual_override, :boolean
  end
end
