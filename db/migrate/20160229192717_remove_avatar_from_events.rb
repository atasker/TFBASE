class RemoveAvatarFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :avatar, :string
  end
end
