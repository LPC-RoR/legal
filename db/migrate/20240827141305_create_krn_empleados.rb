class CreateKrnEmpleados < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_empleados do |t|
      t.integer :cliente_id
      t.integer :empresa_id
      t.string :rut
      t.string :nombre

      t.timestamps
    end
    add_index :krn_empleados, :cliente_id
    add_index :krn_empleados, :empresa_id
    add_index :krn_empleados, :rut
  end
end
