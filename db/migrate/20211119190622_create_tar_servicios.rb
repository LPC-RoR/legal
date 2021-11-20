class CreateTarServicios < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_servicios do |t|
      t.string :codigo
      t.string :descripcion
      t.text :detalle
      t.string :tipo
      t.string :moneda
      t.decimal :monto
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :tar_servicios, :codigo
    add_index :tar_servicios, :tipo
    add_index :tar_servicios, :owner_class
    add_index :tar_servicios, :owner_id
  end
end
