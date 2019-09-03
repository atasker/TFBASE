class DropJoinTableEventTeamsArtist < ActiveRecord::Migration[5.2]
  def change
    drop_join_table :events, :teams_artists
  end
end
