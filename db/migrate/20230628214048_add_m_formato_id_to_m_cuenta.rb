class AddMFormatoIdToMCuenta < ActiveRecord::Migration[5.2]
  def change
    add_column :m_cuentas, :m_formato_id, :integer
    add_index :m_cuentas, :m_formato_id
  end
end
