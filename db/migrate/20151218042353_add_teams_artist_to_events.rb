class AddTeamsArtistToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :teams_artist, index: true, foreign_key: true
  end
end
