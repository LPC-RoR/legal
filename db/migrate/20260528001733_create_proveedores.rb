class CreateProveedores < ActiveRecord::Migration[8.0]
  def change
    create_table :proveedores do |t|
      t.string :razon_social
      t.string :rut

      t.timestamps
    end
    add_index :proveedores, :rut
  end
end
