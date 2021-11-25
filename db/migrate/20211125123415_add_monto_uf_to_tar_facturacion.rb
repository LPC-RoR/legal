class AddMontoUfToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :monto_uf, :decimal
  end
end
