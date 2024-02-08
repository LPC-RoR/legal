class CreateAgeUsuPerfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :age_usu_perfiles do |t|
      t.integer :age_usuario_id
      t.integer :app_perfil_id

      t.timestamps
    end
    add_index :age_usu_perfiles, :age_usuario_id
    add_index :age_usu_perfiles, :app_perfil_id
  end
end
