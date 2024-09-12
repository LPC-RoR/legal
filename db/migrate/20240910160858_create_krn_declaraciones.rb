class CreateKrnDeclaraciones < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_declaraciones do |t|
      t.integer :krn_denuncia_id
      t.string :ownr_type
      t.integer :ownr_id
      t.datetime :fecha
      t.string :archivo

      t.timestamps
    end
    add_index :krn_declaraciones, :krn_denuncia_id
    add_index :krn_declaraciones, :ownr_type
    add_index :krn_declaraciones, :ownr_id
  end
end
