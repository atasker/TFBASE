class AddNoFeeMessageToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :no_fee_message, :string
  end
end
