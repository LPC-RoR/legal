class CreateAppMensajes < ActiveRecord::Migration[5.2]
  def change
    create_table :app_mensajes do |t|
      t.string :mensaje
      t.string :tipo
      t.string :estado
      t.string :email
      t.datetime :fecha_envio
      t.text :detalle
      t.integer :app_perfil_id

      t.timestamps
    end
    add_index :app_mensajes, :tipo
    add_index :app_mensajes, :estado
    add_index :app_mensajes, :email
    add_index :app_mensajes, :fecha_envio
    add_index :app_mensajes, :app_perfil_id
  end
end
