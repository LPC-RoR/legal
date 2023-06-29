class AddColumnaToMElemento < ActiveRecord::Migration[5.2]
  def change
    add_column :m_elementos, :columna, :string
  end
end
