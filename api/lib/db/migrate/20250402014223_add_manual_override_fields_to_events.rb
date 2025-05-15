class AddManualOverrideFieldsToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :manual_override_ticket, :boolean, default: false
    add_column :events, :manual_override_location, :boolean, default: false
    add_column :events, :manual_override_times, :boolean, default: false
    add_column :events, :manual_override_genres, :boolean, default: false
  end
end
