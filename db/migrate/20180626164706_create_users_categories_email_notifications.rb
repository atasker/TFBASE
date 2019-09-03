class CreateUsersCategoriesEmailNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :users_categories_email_notifications do |t|
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
    end
  end
end
