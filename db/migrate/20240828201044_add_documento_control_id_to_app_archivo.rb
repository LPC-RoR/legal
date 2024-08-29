class AddDocumentoControlIdToAppArchivo < ActiveRecord::Migration[7.1]
  def change
    add_column :app_archivos, :documento_control_id, :integer
    add_index :app_archivos, :documento_control_id
  end
end
