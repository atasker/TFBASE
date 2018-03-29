class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :path, null: false
      t.text :body
      t.text :seodata

      t.timestamps null: false
    end

    add_index :pages, :path, unique: true
  end
end
