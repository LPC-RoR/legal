class RenameAppAdministradorIdFromAppPerfil < ActiveRecord::Migration[7.1]
  def change
    rename_column :app_perfiles, :app_administrador_id, :app_nomina_id
  end
end
