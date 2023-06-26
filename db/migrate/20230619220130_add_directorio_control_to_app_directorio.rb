class AddDirectorioControlToAppDirectorio < ActiveRecord::Migration[5.2]
  def change
    add_column :app_directorios, :app_directorio, :string
    add_index :app_directorios, :app_directorio
    add_column :app_directorios, :directorio_control, :boolean
  end
end
