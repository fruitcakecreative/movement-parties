class AddDiceUrlToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :dice_url, :string
    add_index :events, :dice_url
  end
end
