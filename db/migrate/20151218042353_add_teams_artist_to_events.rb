class AddTeamsArtistToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :teams_artist, index: true, foreign_key: true
  end
end
