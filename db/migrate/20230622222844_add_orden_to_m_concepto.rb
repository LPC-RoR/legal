class AddOrdenToMConcepto < ActiveRecord::Migration[5.2]
  def change
    add_column :m_conceptos, :orden, :integer
    add_index :m_conceptos, :orden
  end
end
