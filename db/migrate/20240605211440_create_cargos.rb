class CreateCargos < ActiveRecord::Migration[5.2]
  def change
    create_table :cargos do |t|
      t.integer :tipo_cargo_id
      t.integer :cliente_id
      t.string :cargo
      t.text :detalle
      t.datetime :fecha
      t.datetime :fecha_uf
      t.string :moneda
      t.integer :dia_cargo

      t.timestamps
    end
    add_index :cargos, :tipo_cargo_id
    add_index :cargos, :cliente_id
  end
end
