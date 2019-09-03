class AddEventToTickets < ActiveRecord::Migration[5.2]
  def change
    add_reference :tickets, :event, index: true, foreign_key: true
  end
end
