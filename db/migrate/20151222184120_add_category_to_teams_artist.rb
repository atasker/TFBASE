class AddCategoryToTeamsArtist < ActiveRecord::Migration
  def change
    add_reference :teams_artists, :category, index: true, foreign_key: true
  end
end
