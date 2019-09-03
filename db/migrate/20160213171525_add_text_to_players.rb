class AddTextToPlayers < ActiveRecord::Migration[5.2]
  def change
    add_column :players, :text, :text
  end
end
