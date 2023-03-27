class AddMonedaToTarValorCuantia < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_valor_cuantias, :moneda, :string
  end
end
