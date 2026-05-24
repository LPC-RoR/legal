class DropAppFiles < ActiveRecord::Migration[8.0]
  def change
   drop_table :app_directorios
   drop_table :app_dir_dires
   drop_table :app_escaneos
   drop_table :app_imagenes
   drop_table :app_mensajes
   drop_table :app_msg_msgs
  end
end
