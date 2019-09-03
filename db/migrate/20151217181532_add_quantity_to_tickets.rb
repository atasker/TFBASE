class AddQuantityToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :quantity, :integer
  end
end
