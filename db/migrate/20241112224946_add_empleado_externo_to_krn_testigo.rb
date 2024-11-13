class AddEmpleadoExternoToKrnTestigo < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_testigos, :empleado_externo, :boolean
  end
end
