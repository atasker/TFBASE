class AddCurrencyToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :currency, :string
  end
end
