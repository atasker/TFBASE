class CreateEventInfoBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :event_info_blocks do |t|
      t.references :event, index: true, foreign_key: true
      t.string :title
      t.text :text
      t.integer :prior

      t.timestamps null: false
    end
  end
end
