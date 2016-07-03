class AddAvatarToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :avatar, :string
  end
end
