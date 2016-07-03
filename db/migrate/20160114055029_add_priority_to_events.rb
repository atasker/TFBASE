class AddPriorityToEvents < ActiveRecord::Migration
  def change
    add_column :events, :priority, :boolean, null: false, default: false
  end
end
