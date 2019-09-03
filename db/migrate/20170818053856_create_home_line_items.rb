class CreateHomeLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :home_line_items do |t|
      t.integer :kind, null: false, default: 0
      t.references :competition, index: true, foreign_key: true
      t.references :player, index: true, foreign_key: true
      t.string :title
      t.string :url
      t.string :avatar
      t.integer :prior, null: false, default: 9

      t.timestamps null: false
    end

    add_index :home_line_items, :prior
  end
end
