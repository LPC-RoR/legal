class CreateRcrsEnlaces < ActiveRecord::Migration[8.0]
  def change
    create_table :rcrs_enlaces do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.string :descripcion
      t.string :link
      t.boolean :blank

      t.timestamps
    end
    add_index :rcrs_enlaces, :ownr_type
    add_index :rcrs_enlaces, :ownr_id
  end
end
