class AddFacturadoToTarFacturacion < ActiveRecord::Migration[8.0]
  def change
    add_column :tar_facturaciones, :facturado, :boolean
    add_index :tar_facturaciones, :facturado
  end
end
