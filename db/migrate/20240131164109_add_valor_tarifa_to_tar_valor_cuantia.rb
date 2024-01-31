class AddValorTarifaToTarValorCuantia < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_valor_cuantias, :valor_tarifa, :decimal
  end
end
