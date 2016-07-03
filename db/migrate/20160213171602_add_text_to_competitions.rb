class AddTextToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :text, :text
  end
end
