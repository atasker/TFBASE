class AddSportsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :sports, :boolean, null: false, default: false
  end
end
