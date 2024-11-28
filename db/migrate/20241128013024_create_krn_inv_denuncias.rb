class CreateKrnInvDenuncias < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_inv_denuncias do |t|
      t.integer :krn_investigador_id
      t.integer :krn_denuncia_id

      t.timestamps
    end
    add_index :krn_inv_denuncias, :krn_investigador_id
    add_index :krn_inv_denuncias, :krn_denuncia_id
  end
end
