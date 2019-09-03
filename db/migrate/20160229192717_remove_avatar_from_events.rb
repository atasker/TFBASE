class RemoveAvatarFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :avatar, :string
  end
end
