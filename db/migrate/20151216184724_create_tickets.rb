class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.float :price
      t.integer :category

      t.timestamps null: false
    end
  end
end
