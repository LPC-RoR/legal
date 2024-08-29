class RenameDocumentoControladoId < ActiveRecord::Migration[7.1]
  def change
    rename_column :app_archivos, :documento_control_id, :control_documento_id
  end
end
