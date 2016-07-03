class AddAvatarToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :avatar, :string
  end
end
