class AddTipoClienteToCliente < ActiveRecord::Migration[5.2]
  def change
    add_column :clientes, :tipo_cliente, :string
    add_index :clientes, :tipo_cliente
  end
end
