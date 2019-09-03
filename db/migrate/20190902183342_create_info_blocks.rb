class CreateInfoBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :info_blocks do |t|
      t.string :title
      t.text :text
      t.integer :prior
      t.references :info_blockable, polymorphic: true

      t.timestamps
    end
  end
end
