class AddFlagsToMFormato < ActiveRecord::Migration[5.2]
  def change
    add_column :m_formatos, :inicio, :string
    add_column :m_formatos, :termino, :string
  end
end
