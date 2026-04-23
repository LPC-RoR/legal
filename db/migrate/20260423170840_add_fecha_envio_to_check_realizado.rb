class AddFechaEnvioToCheckRealizado < ActiveRecord::Migration[8.0]
  def change
    add_column :check_realizados, :fecha_envio, :datetime
  end
end
