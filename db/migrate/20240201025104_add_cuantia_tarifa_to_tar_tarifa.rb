class AddCuantiaTarifaToTarTarifa < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_tarifas, :cuantia_tarifa, :boolean
  end
end
