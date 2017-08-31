class AddSlugToSluggableObjects < ActiveRecord::Migration
  def change
    add_column :categories, :slug, :string
    add_column :competitions, :slug, :string
    add_column :events, :slug, :string
    add_column :players, :slug, :string
    add_index :categories, :slug, unique: true
    add_index :competitions, :slug, unique: true
    add_index :events, :slug, unique: true
    add_index :players, :slug, unique: true
  end
end
