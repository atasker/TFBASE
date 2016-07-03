class AddSportsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :sports, :boolean, null: false, default: false
  end
end
