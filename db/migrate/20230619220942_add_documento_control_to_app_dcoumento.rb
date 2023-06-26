class AddDocumentoControlToAppDcoumento < ActiveRecord::Migration[5.2]
  def change
    add_column :app_documentos, :app_documento, :string
    add_index :app_documentos, :app_documento
    add_column :app_documentos, :existencia, :string
    add_column :app_documentos, :vencimiento, :string
    add_column :app_documentos, :documento_control, :boolean
    add_column :app_documentos, :referencia, :string
  end
end
