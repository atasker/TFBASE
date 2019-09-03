class ChangeTicketCategoryToString < ActiveRecord::Migration[5.2]
  def change
    change_column(:tickets, :category, :string)
  end
end
