class RenameTeamsArtistToPlayer < ActiveRecord::Migration
  def change
    rename_table :teams_artists, :players
  end
end
