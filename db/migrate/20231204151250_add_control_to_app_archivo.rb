class AddControlToAppArchivo < ActiveRecord::Migration[5.2]
  def change
    add_column :app_archivos, :documento_control, :boolean
    add_index :app_archivos, :documento_control
    add_column :app_archivos, :control, :string
    add_index :app_archivos, :control
  end
end
