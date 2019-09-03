class AddTextToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :text, :text
  end
end
