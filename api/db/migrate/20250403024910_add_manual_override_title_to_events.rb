class AddManualOverrideTitleToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :manual_override_title, :boolean
  end
end
