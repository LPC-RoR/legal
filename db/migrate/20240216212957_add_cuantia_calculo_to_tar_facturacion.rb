class AddCuantiaCalculoToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :cuantia_calculo, :decimal
  end
end
