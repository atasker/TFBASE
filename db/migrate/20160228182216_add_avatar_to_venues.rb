class AddAvatarToVenues < ActiveRecord::Migration[5.2]
  def change
    add_column :venues, :avatar, :string
  end
end
