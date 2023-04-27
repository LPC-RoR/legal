class AddFechaFacturaToTarFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturas, :fecha_factura, :datetime
  end
end
