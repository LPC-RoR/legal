class AddMRegistroIdToTarFactura < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_facturas, :m_registro_id, :integer
    add_index :tar_facturas, :m_registro_id
  end
end
