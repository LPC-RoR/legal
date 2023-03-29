class AddMonedaToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :moneda, :string
    add_index :tar_facturaciones, :moneda
  end
end
