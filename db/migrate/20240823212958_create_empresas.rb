class CreateEmpresas < ActiveRecord::Migration[7.1]
  def change
    create_table :empresas do |t|
      t.string :rut
      t.string :razon_social
      t.string :email_administrador
      t.string :email_verificado
      t.string :sha1

      t.timestamps
    end
    add_index :empresas, :rut
    add_index :empresas, :sha1
  end
end
