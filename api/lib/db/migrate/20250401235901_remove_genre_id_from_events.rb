class RemoveGenreIdFromEvents < ActiveRecord::Migration[7.2]
  def change
    remove_column :events, :genre_id, :bigint
  end
end
