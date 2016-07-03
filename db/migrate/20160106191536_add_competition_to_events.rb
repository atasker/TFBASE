class AddCompetitionToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :competition, index: true, foreign_key: true
  end
end
