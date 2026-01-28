class DropMTablesSec < ActiveRecord::Migration[8.0]
  def change
   drop_table :m_reg_facts
   drop_table :m_valores
  end
end
