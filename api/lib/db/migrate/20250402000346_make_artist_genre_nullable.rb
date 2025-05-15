class MakeArtistGenreNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :artists, :genre_id, true
  end
end
