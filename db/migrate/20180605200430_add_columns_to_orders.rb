class AddColumnsToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :user, index: true, foreign_key: true
    add_column :orders, :guid, :string, null: false
    add_column :orders, :currency, :string
    add_column :orders, :shipping, :float
    add_column :orders, :txn_id, :string
    add_column :orders, :payer_paypal_id, :string
    add_column :orders, :address_name, :string
    add_column :orders, :address_country, :string
    add_column :orders, :address_country_code, :string
    add_column :orders, :address_zip, :string
    add_column :orders, :address_state, :string
    add_column :orders, :address_city, :string
    add_column :orders, :address_street, :string
    add_index :orders, :guid
    add_index :orders, :txn_id
  end
end
