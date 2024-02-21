class AddTarCuotaIdToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :tar_cuota_id, :integer
    add_index :tar_facturaciones, :tar_cuota_id
  end
end
