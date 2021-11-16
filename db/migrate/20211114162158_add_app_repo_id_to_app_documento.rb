class AddAppRepoIdToAppDocumento < ActiveRecord::Migration[5.2]
  def change
    add_column :app_documentos, :app_repo_id, :integer
    add_index :app_documentos, :app_repo_id
  end
end
