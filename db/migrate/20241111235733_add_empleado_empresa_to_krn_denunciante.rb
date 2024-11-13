class AddEmpleadoEmpresaToKrnDenunciante < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denunciantes, :empleado_externo, :boolean
    add_column :krn_denunciados, :empleado_externo, :boolean
  end
end
