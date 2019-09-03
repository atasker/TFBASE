class AddCurrencyToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :currency, :string
  end
end
