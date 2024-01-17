class AddAbonoCargoToMItem < ActiveRecord::Migration[5.2]
  def change
    add_column :m_items, :abono_cargo, :string
    add_index :m_items, :abono_cargo
  end
end
