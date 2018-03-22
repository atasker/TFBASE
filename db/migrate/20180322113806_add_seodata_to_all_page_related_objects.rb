class AddSeodataToAllPageRelatedObjects < ActiveRecord::Migration
  def change
    add_column :categories, :seodata, :text
  end
end
