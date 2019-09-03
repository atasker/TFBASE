class CreateEnquiries < ActiveRecord::Migration[5.2]
  def change
    create_table :enquiries do |t|
      t.references :ticket, index: true, foreign_key: true, null: false
      t.string :name
      t.string :email
      t.text :body

      t.timestamps null: false
    end
  end
end
