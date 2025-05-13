class ChangeGenreIdInEvents < ActiveRecord::Migration[7.0]
  def change
    change_column_null :events, :genre_id, true
  end
end
