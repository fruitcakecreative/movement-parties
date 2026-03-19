# frozen_string_literal: true

class AddEdmTrainUrlToEvents < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :edm_train_url, :string
    add_index :events, :edm_train_url
  end
end
