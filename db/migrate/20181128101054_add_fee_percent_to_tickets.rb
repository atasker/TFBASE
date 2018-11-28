class AddFeePercentToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :fee_percent, :float
  end
end
