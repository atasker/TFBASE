class AddCompetitionToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :competition, index: true, foreign_key: true
  end
end
