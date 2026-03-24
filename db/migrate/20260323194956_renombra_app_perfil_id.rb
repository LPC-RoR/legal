class RenombraAppPerfilId < ActiveRecord::Migration[8.0]
  def change
    rename_column :check_realizados, :app_perfil_id, :usuario_id
  end
end
