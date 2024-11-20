class AddFechaEnvioToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :fecha_env_infrm, :datetime
  end
end
