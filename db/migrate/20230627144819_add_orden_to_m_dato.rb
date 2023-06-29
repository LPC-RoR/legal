class AddOrdenToMDato < ActiveRecord::Migration[5.2]
  def change
    add_column :m_datos, :orden, :integer
    add_index :m_datos, :orden
  end
end
