class CreateKrnDenuncias < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_denuncias do |t|
      t.integer :cliente_id
      t.integer :receptor_denuncia_id
      t.integer :empresa_receptora_id
      t.integer :motivo_denuncia_id
      t.integer :investigador_id
      t.datetime :fecha_hora
      t.datetime :fecha_hora_dt
      t.datetime :fecha_hora_recepcion

      t.timestamps
    end
    add_index :krn_denuncias, :cliente_id
    add_index :krn_denuncias, :receptor_denuncia_id
    add_index :krn_denuncias, :empresa_receptora_id
    add_index :krn_denuncias, :motivo_denuncia_id
    add_index :krn_denuncias, :investigador_id
    add_index :krn_denuncias, :fecha_hora
    add_index :krn_denuncias, :fecha_hora_dt
    add_index :krn_denuncias, :fecha_hora_recepcion
  end
end
