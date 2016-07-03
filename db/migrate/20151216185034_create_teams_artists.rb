class CreateTeamsArtists < ActiveRecord::Migration
  def change
    create_table :teams_artists do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
