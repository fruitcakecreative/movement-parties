class AddFieldsToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :even_shorter_title, :string
    add_column :events, :free_event, :boolean
    add_column :events, :food_available, :boolean
    add_column :events, :indoor_outdoor, :string
    add_column :events, :age, :string
    add_column :events, :promoter, :string
    add_column :events, :notes, :text
  end
end
