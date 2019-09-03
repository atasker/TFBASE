class AddAvatarToCompetitions < ActiveRecord::Migration[5.2]
  def change
    add_column :competitions, :avatar, :string
  end
end
