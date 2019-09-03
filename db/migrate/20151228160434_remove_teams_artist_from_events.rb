class RemoveTeamsArtistFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :teams_artist_id, :integer
  end
end
