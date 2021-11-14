class CreateStPerfilModelos < ActiveRecord::Migration[5.2]
  def change
    create_table :st_perfil_modelos do |t|
      t.string :st_perfil_modelo
      t.string :rol
      t.boolean :ingresa_registros
      t.integer :app_nomina_id

      t.timestamps
    end
    add_index :st_perfil_modelos, :app_nomina_id
  end
end
