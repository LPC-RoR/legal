class AddAppAchivoToAppArchivo < ActiveRecord::Migration[5.2]
  def change
    add_column :app_archivos, :app_archivo, :string
  end
end
