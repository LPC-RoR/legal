class CreateTarNotaCreditos < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_nota_creditos do |t|
      t.integer :numero
      t.datetime :fecha
      t.decimal :monto
      t.boolean :monto_total
      t.integer :tar_factura_id

      t.timestamps
    end
    add_index :tar_nota_creditos, :numero
    add_index :tar_nota_creditos, :fecha
    add_index :tar_nota_creditos, :tar_factura_id
  end
end
