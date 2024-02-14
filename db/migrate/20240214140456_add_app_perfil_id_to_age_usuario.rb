class AddAppPerfilIdToAgeUsuario < ActiveRecord::Migration[5.2]
  def change
    add_column :age_usuarios, :app_perfil_id, :integer
    add_index :age_usuarios, :app_perfil_id
  end
end
