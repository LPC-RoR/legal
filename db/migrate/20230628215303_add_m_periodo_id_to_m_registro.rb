class AddMPeriodoIdToMRegistro < ActiveRecord::Migration[5.2]
  def change
    add_column :m_registros, :m_periodo_id, :integer
    add_index :m_registros, :m_periodo_id
  end
end
