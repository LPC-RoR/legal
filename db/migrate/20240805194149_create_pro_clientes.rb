class CreateProClientes < ActiveRecord::Migration[7.1]
  def change
    create_table :pro_clientes do |t|
      t.integer :cliente_id
      t.integer :producto_id

      t.timestamps
    end
    add_index :pro_clientes, :cliente_id
    add_index :pro_clientes, :producto_id
  end
end
