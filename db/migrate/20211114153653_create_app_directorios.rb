class CreateAppDirectorios < ActiveRecord::Migration[5.2]
  def change
    create_table :app_directorios do |t|
      t.string :directorio
      t.integer :app_repo_id

      t.timestamps
    end
    add_index :app_directorios, :directorio
    add_index :app_directorios, :app_repo_id
  end
end
