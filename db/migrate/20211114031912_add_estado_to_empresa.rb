class AddEstadoToEmpresa < ActiveRecord::Migration[5.2]
  def change
    add_column :clientes, :estado, :string
    add_index :clientes, :estado
  end
end
