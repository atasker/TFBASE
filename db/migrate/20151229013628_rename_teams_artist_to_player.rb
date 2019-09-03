class RenameTeamsArtistToPlayer < ActiveRecord::Migration[5.2]
  def change
    rename_table :teams_artists, :players
  end
end
