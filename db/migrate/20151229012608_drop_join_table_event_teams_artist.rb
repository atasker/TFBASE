class DropJoinTableEventTeamsArtist < ActiveRecord::Migration
  def change
    drop_join_table :events, :teams_artists
  end
end
