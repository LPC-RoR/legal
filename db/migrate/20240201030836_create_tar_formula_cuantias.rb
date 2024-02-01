class CreateTarFormulaCuantias < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_formula_cuantias do |t|
      t.integer :tar_tarifa_id
      t.integer :tar_detalle_cuantia_id
      t.string :tar_formula_cuantia

      t.timestamps
    end
    add_index :tar_formula_cuantias, :tar_tarifa_id
    add_index :tar_formula_cuantias, :tar_detalle_cuantia_id
  end
end
