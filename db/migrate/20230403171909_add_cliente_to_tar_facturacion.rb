class AddClienteToTarFacturacion < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturaciones, :cliente_class, :string
    add_index :tar_facturaciones, :cliente_class
    add_column :tar_facturaciones, :cliente_id, :integer
    add_index :tar_facturaciones, :cliente_id
  end
end
