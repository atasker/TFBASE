class CreateHomeSlides < ActiveRecord::Migration
  def change
    create_table :home_slides do |t|
      t.integer :kind, null: false, default: 0
      t.string :huge_image
      t.string :big_image
      t.string :tile_image
      t.boolean :manual_input
      t.references :event, index: true, foreign_key: true
      t.string :title
      t.string :url
      t.string :avatar
      t.string :place
      t.date :start_date
      t.date :end_date
      t.references :category, foreign_key: true
      t.integer :prior, null: false, default: 9

      t.timestamps null: false
    end
  end
end
