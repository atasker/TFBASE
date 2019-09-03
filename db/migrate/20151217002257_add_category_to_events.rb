class AddCategoryToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :category, index: true, foreign_key: true
  end
end
