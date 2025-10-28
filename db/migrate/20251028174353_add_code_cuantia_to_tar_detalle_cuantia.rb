class AddCodeCuantiaToTarDetalleCuantia < ActiveRecord::Migration[8.0]
  def change
    add_column :tar_detalle_cuantias, :code_cuantia, :string
    add_index :tar_detalle_cuantias, :code_cuantia
    add_column :tar_formula_cuantias, :code_cuantia, :string
    add_index :tar_formula_cuantias, :code_cuantia
    add_column :tar_valor_cuantias, :code_cuantia, :string
    add_index :tar_valor_cuantias, :code_cuantia
  end
end
