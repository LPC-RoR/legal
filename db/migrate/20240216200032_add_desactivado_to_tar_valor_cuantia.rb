class AddDesactivadoToTarValorCuantia < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_valor_cuantias, :desactivado, :boolean
    add_index :tar_valor_cuantias, :desactivado
  end
end
