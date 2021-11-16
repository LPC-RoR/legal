class CreateClientes < ActiveRecord::Migration[5.2]
  def change
    create_table :clientes do |t|
      t.string :razon_social
      t.string :rut

      t.timestamps
    end
  end
end
