class AddRelationFieldsToAppDirectorio < ActiveRecord::Migration[5.2]
  def change
    add_column :app_directorios, :owner_class, :string
    add_index :app_directorios, :owner_class
    add_column :app_directorios, :owner_id, :integer
    add_index :app_directorios, :owner_id
  end
end
