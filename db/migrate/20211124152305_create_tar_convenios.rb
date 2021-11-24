class CreateTarConvenios < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_convenios do |t|
      t.datetime :fecha
      t.decimal :monto
      t.string :estado
      t.integer :tar_factura_id
      t.integer :tar_facturacion_id

      t.timestamps
    end
    add_index :tar_convenios, :fecha
    add_index :tar_convenios, :estado
    add_index :tar_convenios, :tar_factura_id
    add_index :tar_convenios, :tar_facturacion_id
  end
end
