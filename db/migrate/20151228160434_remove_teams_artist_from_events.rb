class RemoveTeamsArtistFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :teams_artist_id, :integer
  end
end
