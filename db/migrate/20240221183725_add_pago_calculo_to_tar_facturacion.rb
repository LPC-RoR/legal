class AddPagoCalculoToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :pago_calculo, :decimal
  end
end
