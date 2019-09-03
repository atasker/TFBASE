class AddCategoryToTeamsArtist < ActiveRecord::Migration[5.2]
  def change
    add_reference :teams_artists, :category, index: true, foreign_key: true
  end
end
