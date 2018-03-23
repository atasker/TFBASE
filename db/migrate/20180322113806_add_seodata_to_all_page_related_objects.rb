class AddSeodataToAllPageRelatedObjects < ActiveRecord::Migration
  def change
    add_column :categories, :seodata, :text
    add_column :competitions, :seodata, :text
    add_column :events, :seodata, :text
  end
end
