class CreateRegistros < ActiveRecord::Migration[5.2]
  def change
    create_table :registros do |t|
      t.string :owner_class
      t.integer :owner_id
      t.datetime :fecha
      t.string :tipo
      t.string :detalle
      t.text :nota
      t.time :duracion
      t.time :descuento
      t.string :razon_descuento
      t.string :estado

      t.timestamps
    end
    add_index :registros, :owner_class
    add_index :registros, :owner_id
    add_index :registros, :fecha
    add_index :registros, :tipo
    add_index :registros, :estado
  end
end
