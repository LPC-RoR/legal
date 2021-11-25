class AddConceptoToTarFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturas, :concepto, :string
  end
end
