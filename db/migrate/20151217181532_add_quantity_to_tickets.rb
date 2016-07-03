class AddQuantityToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :quantity, :integer
  end
end
