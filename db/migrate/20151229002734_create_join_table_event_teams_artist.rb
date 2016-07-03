class CreateJoinTableEventTeamsArtist < ActiveRecord::Migration
  def change
    create_join_table :events, :teams_artists do |t|
      t.index [:event_id, :teams_artist_id]
      t.index [:teams_artist_id, :event_id]
    end
  end
end
