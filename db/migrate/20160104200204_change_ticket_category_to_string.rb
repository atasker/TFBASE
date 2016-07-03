class ChangeTicketCategoryToString < ActiveRecord::Migration
  def change
    change_column(:tickets, :category, :string)
  end
end
