class AddEnquireToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :enquire, :boolean
  end
end
