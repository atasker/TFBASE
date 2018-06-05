class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :order_items do |t|
      t.references :order, index: true, foreign_key: true, null: false
      t.float :price
      t.string :currency
      t.integer :quantity
      t.text :descr

      t.timestamps null: false
    end
  end
end
