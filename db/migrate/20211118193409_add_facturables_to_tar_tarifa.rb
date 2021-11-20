class AddFacturablesToTarTarifa < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_tarifas, :facturables, :string
    add_index :tar_tarifas, :facturables
  end
end
