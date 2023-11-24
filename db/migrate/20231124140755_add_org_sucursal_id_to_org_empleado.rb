class AddOrgSucursalIdToOrgEmpleado < ActiveRecord::Migration[5.2]
  def change
    add_column :org_empleados, :org_sucursal_id, :integer
    add_index :org_empleados, :org_sucursal_id
  end
end
