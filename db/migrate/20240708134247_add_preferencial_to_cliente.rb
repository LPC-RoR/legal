class AddPreferencialToCliente < ActiveRecord::Migration[7.1]
  def change
    add_column :clientes, :preferente, :boolean
  end
end
