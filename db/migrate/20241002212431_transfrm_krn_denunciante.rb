class TransfrmKrnDenunciante < ActiveRecord::Migration[7.1]
  def change
    remove_index :krn_denunciantes, :dependencia_denunciante_id
    remove_column :krn_denunciantes, :dependencia_denunciante_id, :integer
    remove_index :krn_denunciantes, :krn_empleado_id
    remove_column :krn_denunciantes, :krn_empleado_id, :integer

    remove_column :krn_denunciantes, :representante, :integer
    remove_column :krn_denunciantes, :doc_representante, :integer

    drop_table :krn_empleados
  end
end
