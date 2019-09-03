class AddSportsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :sports, :boolean, null: false, default: false
  end
end
