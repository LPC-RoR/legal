class AddFormulaToTarDetalleCuantia < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_detalle_cuantias, :formula_cuantia, :string
    add_column :tar_detalle_cuantias, :formula_honorarios, :string
  end
end
