class CreateTarDetalleCuantias < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_detalle_cuantias do |t|
      t.string :tar_detalle_cuantia
      t.string :descripcion

      t.timestamps
    end
    add_index :tar_detalle_cuantias, :tar_detalle_cuantia
  end
end
