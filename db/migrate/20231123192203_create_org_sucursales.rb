class CreateOrgSucursales < ActiveRecord::Migration[5.2]
  def change
    create_table :org_sucursales do |t|
      t.string :org_sucursal
      t.string :direccion
      t.integer :org_region_id

      t.timestamps
    end
    add_index :org_sucursales, :org_sucursal
    add_index :org_sucursales, :org_region_id
  end
end
