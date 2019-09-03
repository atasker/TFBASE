class CreateJoinTableEventPlayer < ActiveRecord::Migration[5.2]
  def change
    create_join_table :events, :players do |t|
      t.index [:event_id, :player_id]
      t.index [:player_id, :event_id]
    end
  end
end
