class AddAvatarToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :avatar, :string
  end
end
