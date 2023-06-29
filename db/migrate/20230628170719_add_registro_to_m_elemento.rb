class AddRegistroToMElemento < ActiveRecord::Migration[5.2]
  def change
    add_column :m_elementos, :registro, :string
  end
end
