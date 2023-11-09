class CreateOrgEmpleados < ActiveRecord::Migration[5.2]
  def change
    create_table :org_empleados do |t|
      t.string :rut
      t.string :nombres
      t.string :apellido_paterno
      t.string :apellido_materno
      t.integer :org_cargo_id
      t.datetime :fecha_nacimiento

      t.timestamps
    end
    add_index :org_empleados, :org_cargo_id
  end
end
