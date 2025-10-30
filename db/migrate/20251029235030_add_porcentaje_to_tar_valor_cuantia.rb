class AddPorcentajeToTarValorCuantia < ActiveRecord::Migration[8.0]
  def change
    add_column :tar_valor_cuantias, :porcentaje, :decimal
  end
end
