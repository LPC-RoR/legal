class RenombrarFechaEnvio < ActiveRecord::Migration[8.0]
  def change
    rename_column :act_archivos, :feha_envio, :fecha_envio
  end
end
