class CreateTxtEditables < ActiveRecord::Migration[8.0]
  def change
    create_table :txt_editables do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.string :codigo
      t.string :titulo

      t.timestamps
    end
    add_index :txt_editables, :ownr_type
    add_index :txt_editables, :ownr_id
    add_index :txt_editables, :codigo
  end
end
