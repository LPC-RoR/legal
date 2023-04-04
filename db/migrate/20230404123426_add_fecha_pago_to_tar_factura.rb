class AddFechaPagoToTarFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturas, :fecha_pago, :datetime
    add_index :tar_facturas, :fecha_pago
  end
end
