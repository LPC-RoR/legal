class AddTarFacturaIdToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :tar_factura_id, :integer
    add_index :tar_facturaciones, :tar_factura_id
  end
end
