class AddTarTarifaIdToTipoCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :tipo_causas, :tar_tarifa_id, :integer
    add_index :tipo_causas, :tar_tarifa_id
  end
end
