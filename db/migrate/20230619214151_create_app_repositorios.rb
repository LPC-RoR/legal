class CreateAppRepositorios < ActiveRecord::Migration[5.2]
  def change
    create_table :app_repositorios do |t|
      t.string :app_repositorio
      t.string :owner_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :app_repositorios, :app_repositorio
    add_index :app_repositorios, :owner_class
    add_index :app_repositorios, :owner_id
  end
end
