class AddMItemIdToMRegistro < ActiveRecord::Migration[5.2]
  def change
    add_column :m_registros, :m_item_id, :integer
    add_index :m_registros, :m_item_id
  end
end
