class AddPrincipalUsuariaToCliente < ActiveRecord::Migration[8.0]
  def change
    add_column :clientes, :principal_usuaria, :boolean
  end
end
