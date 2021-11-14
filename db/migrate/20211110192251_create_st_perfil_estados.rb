class CreateStPerfilEstados < ActiveRecord::Migration[5.2]
  def change
    create_table :st_perfil_estados do |t|
      t.string :st_perfil_estado
      t.string :rol
      t.integer :st_perfil_modelo_id

      t.timestamps
    end
    add_index :st_perfil_estados, :st_perfil_modelo_id
  end
end
