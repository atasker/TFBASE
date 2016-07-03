class AddPairsOnlyToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :pairs_only, :boolean, null: false, default: false
  end
end
