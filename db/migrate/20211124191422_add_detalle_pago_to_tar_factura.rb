class AddDetallePagoToTarFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturas, :detalle_pago, :string
  end
end
