class AddDireccionNotificacionToKrnDenunciante < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denunciantes, :direccion_notificacion, :string
    add_column :krn_denunciados, :direccion_notificacion, :string
  end
end
