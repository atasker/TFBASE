class AddTextToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :text, :text
  end
end
