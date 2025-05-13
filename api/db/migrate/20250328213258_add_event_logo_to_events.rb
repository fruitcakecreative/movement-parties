class AddEventLogoToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :event_logo, :string
  end
end
