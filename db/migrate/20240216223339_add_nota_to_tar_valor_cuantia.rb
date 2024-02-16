class AddNotaToTarValorCuantia < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_valor_cuantias, :nota, :string
  end
end
