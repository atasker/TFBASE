class AddPairsOnlyToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :pairs_only, :boolean, null: false, default: false
  end
end
