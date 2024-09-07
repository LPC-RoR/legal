class CreateKrnDerivaciones < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_derivaciones do |t|
      t.integer :krn_denuncia_id
      t.datetime :fecha
      t.integer :krn_empresa_externa_id
      t.integer :krn_motivo_denuncia_id
      t.string :otro_motivo

      t.timestamps
    end
    add_index :krn_derivaciones, :krn_denuncia_id
    add_index :krn_derivaciones, :fecha
    add_index :krn_derivaciones, :krn_empresa_externa_id
    add_index :krn_derivaciones, :krn_motivo_denuncia_id
  end
end
