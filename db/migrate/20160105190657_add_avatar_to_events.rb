class AddAvatarToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :avatar, :string
  end
end
