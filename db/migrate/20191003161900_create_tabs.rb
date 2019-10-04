class CreateTabs < ActiveRecord::Migration[5.2]
  def change
    create_table :tabs do |t|
      t.string :name
      t.text :content
      t.integer :prior
      t.references :tabable, polymorphic: true

      t.timestamps
    end
  end
end
