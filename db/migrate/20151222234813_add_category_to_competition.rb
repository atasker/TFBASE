class AddCategoryToCompetition < ActiveRecord::Migration[5.2]
  def change
    add_reference :competitions, :category, index: true, foreign_key: true
  end
end
