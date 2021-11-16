class RemoveAppRepoIdFromAppDirectorio < ActiveRecord::Migration[5.2]
  def change
    remove_index :app_directorios, :app_repo_id
    remove_column :app_directorios, :app_repo_id, :integer
  end
end
