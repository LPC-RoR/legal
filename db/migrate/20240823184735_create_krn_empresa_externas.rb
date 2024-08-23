class CreateKrnEmpresaExternas < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_empresa_externas do |t|
      t.string :rut
      t.string :razon_social
      t.string :tipo
      t.string :contacto
      t.string :email_contacto

      t.timestamps
    end
    add_index :krn_empresa_externas, :rut
    add_index :krn_empresa_externas, :tipo
  end
end
