class AddActivaDevolucionToCliente < ActiveRecord::Migration[8.0]
  def change
    add_column :clientes, :activa_devolucion, :boolean
  end
end
