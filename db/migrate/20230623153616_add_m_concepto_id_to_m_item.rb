class AddMConceptoIdToMItem < ActiveRecord::Migration[5.2]
  def change
    add_column :m_items, :m_concepto_id, :integer
    add_index :m_items, :m_concepto_id
  end
end
