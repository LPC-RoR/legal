class CreateAppPerfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :app_perfiles do |t|
      t.string :email
      t.integer :usuario_id
      t.integer :app_administrador_id

      t.timestamps
    end
    add_index :app_perfiles, :email
    add_index :app_perfiles, :usuario_id
    add_index :app_perfiles, :app_administrador_id
  end
end
