class AddTenantToUsuarios < ActiveRecord::Migration[8.0]
  def change
    # 1. Crear un tenant temporal
    tenant = Tenant.create!(nombre: "Default Tenant")

    # 2. Agregar la columna
    add_reference :usuarios, :tenant, null: true, foreign_key: true

    # 3. Asignar el tenant a todos los usuarios
    Usuario.update_all(tenant_id: tenant.id)

    # 4. Cambiar a NOT NULL
    change_column_null :usuarios, :tenant_id, false
  end
end
