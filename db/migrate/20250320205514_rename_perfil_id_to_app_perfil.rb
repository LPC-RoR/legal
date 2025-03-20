class RenamePerfilIdToAppPerfil < ActiveRecord::Migration[8.0]
  def change
    rename_column :notas, :perfil_id, :app_perfil_id
  end
end
