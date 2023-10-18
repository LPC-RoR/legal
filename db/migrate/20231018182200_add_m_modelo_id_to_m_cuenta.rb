class AddMModeloIdToMCuenta < ActiveRecord::Migration[5.2]
  def change
    add_column :m_cuentas, :m_modelo_id, :integer
    add_index :m_cuentas, :m_modelo_id
  end
end
