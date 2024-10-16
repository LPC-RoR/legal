class AddOwnrToTarValorCuantia < ActiveRecord::Migration[7.1]
  def change
    add_column :tar_valor_cuantias, :ownr_type, :string
    add_index :tar_valor_cuantias, :ownr_type
    add_column :tar_valor_cuantias, :ownr_id, :integer
    add_index :tar_valor_cuantias, :ownr_id
  end
end
