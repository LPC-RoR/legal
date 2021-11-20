class AddTarTarifaIdToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :tar_tarifa_id, :integer
    add_index :causas, :tar_tarifa_id
  end
end
