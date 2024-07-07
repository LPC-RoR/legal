class AddPointsToCliente < ActiveRecord::Migration[7.1]
  def change
    add_column :clientes, :pendiente, :boolean
    add_column :clientes, :urgente, :boolean
  end
end
