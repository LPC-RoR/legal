class AddTarAprobacionIdToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :tar_aprobacion_id, :integer
    add_index :tar_facturaciones, :tar_aprobacion_id
  end
end
