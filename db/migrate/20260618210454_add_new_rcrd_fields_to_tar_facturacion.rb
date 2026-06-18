class AddNewRcrdFieldsToTarFacturacion < ActiveRecord::Migration[8.0]
  def change
    add_column :tar_facturaciones, :recalcular, :boolean
    add_column :tar_facturaciones, :tipo_monto, :string
    add_column :tar_facturaciones, :monto_parcial, :decimal
    add_column :tar_facturaciones, :porcentaje, :decimal
  end
end
