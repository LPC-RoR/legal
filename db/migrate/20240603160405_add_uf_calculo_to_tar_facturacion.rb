class AddUfCalculoToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :fecha_uf, :datetime
  end
end
