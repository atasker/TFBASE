class AddPriorityToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :priority, :boolean, null: false, default: false
  end
end
