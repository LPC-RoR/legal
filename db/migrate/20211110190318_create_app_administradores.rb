class CreateAppAdministradores < ActiveRecord::Migration[5.2]
  def change
    create_table :app_administradores do |t|
      t.string :administrador
      t.string :email
      t.integer :usuario_id

      t.timestamps
    end
    add_index :app_administradores, :email
    add_index :app_administradores, :usuario_id
  end
end
