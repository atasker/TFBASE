class AddTextToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :text, :text
  end
end
