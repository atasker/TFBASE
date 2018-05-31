class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.references :cart, index: true, foreign_key: true, null: false
      t.references :ticket, index: true, foreign_key: true, null: false
      t.integer :amount, null: false, default: 0

      t.timestamps null: false
    end
  end
end
