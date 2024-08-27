class AddKrnEmpleadoIdToKrnDenunciado < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denunciados, :krn_empleado_id, :integer
    add_index :krn_denunciados, :krn_empleado_id
  end
end
