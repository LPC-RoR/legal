class AddMModeloIdToMRegistro < ActiveRecord::Migration[5.2]
  def change
    add_column :m_registros, :m_modelo_id, :integer
    add_index :m_registros, :m_modelo_id
  end
end
