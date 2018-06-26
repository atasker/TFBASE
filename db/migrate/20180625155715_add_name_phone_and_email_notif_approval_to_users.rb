class AddNamePhoneAndEmailNotifApprovalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :phone, :string
    add_column :users, :agree_email, :boolean
    add_index :users, :agree_email
  end
end
