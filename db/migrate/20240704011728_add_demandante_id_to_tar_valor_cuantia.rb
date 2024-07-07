class AddDemandanteIdToTarValorCuantia < ActiveRecord::Migration[7.1]
  def change
    add_column :tar_valor_cuantias, :demandante_id, :integer
    add_index :tar_valor_cuantias, :demandante_id
  end
end
