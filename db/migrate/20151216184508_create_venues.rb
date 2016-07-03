class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.integer :capacity
      t.string :city
      t.string :country

      t.timestamps null: false
    end
  end
end
