class AddTarCalculoIdToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :tar_calculo_id, :integer
    add_index :tar_facturaciones, :tar_calculo_id
  end
end
