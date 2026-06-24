class AddCliAprobacionToTarFacturacion < ActiveRecord::Migration[8.0]
  def change
    add_reference :tar_facturaciones, :cli_aprobacion, 
                foreign_key: true, 
                null: true
  end
end
