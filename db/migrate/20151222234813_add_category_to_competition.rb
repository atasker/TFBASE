class AddCategoryToCompetition < ActiveRecord::Migration
  def change
    add_reference :competitions, :category, index: true, foreign_key: true
  end
end
