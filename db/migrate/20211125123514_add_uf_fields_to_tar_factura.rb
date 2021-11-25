class AddUfFieldsToTarFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturas, :fecha_uf, :datetime
    add_column :tar_facturas, :uf_factura, :decimal
  end
end
