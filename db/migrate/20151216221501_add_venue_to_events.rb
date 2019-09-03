class AddVenueToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :venue, index: true, foreign_key: true
  end
end
