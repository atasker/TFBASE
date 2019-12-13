# This migration comes from blogo (originally 20140218134512)
class CreateBlogoTags < ActiveRecord::Migration[5.2]
  def change
    tags_table = "#{Blogo.table_name_prefix}tags"

    create_table(tags_table) do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index tags_table, :name, unique: true
  end
end
