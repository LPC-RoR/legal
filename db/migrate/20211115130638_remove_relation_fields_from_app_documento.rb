class RemoveRelationFieldsFromAppDocumento < ActiveRecord::Migration[5.2]
  def change
    remove_index :app_documentos, :app_repo_id
    remove_column :app_documentos, :app_repo_id, :integer
    remove_index :app_documentos, :app_directorio_id
    remove_column :app_documentos, :app_directorio_id, :integer
  end
end
