class AddTextToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :text, :text
  end
end
