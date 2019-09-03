class AddSeodataToAllPageRelatedObjects < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :seodata, :text
    add_column :competitions, :seodata, :text
    add_column :events, :seodata, :text
    add_column :players, :seodata, :text
  end
end
