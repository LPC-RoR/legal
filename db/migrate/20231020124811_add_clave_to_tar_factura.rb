class AddClaveToTarFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturas, :clave, :integer
    add_index :tar_facturas, :clave
  end
end
