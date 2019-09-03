class AddSportsToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :sports, :boolean, null: false, default: false
  end
end
