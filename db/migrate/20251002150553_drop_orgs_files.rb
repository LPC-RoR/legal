class DropOrgsFiles < ActiveRecord::Migration[8.0]
  def change
    drop_table :org_areas
    drop_table :org_cargos
    drop_table :org_empleados
    drop_table :org_regiones
    drop_table :org_sucursales
  end
end
