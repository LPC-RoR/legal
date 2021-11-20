class CreateTarDetalles < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_detalles do |t|
      t.integer :orden
      t.string :codigo
      t.string :detalle
      t.string :tipo
      t.string :formula
      t.integer :tar_tarifa_id

      t.timestamps
    end
    add_index :tar_detalles, :orden
    add_index :tar_detalles, :codigo
    add_index :tar_detalles, :tar_tarifa_id
  end
end
