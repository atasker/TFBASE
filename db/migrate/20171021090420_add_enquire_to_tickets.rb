class AddEnquireToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :enquire, :boolean
  end
end
