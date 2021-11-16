class CreateAppRepos < ActiveRecord::Migration[5.2]
  def change
    create_table :app_repos do |t|
      t.string :repositorio
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :app_repos, :repositorio
    add_index :app_repos, :owner_class
    add_index :app_repos, :owner_id
  end
end
