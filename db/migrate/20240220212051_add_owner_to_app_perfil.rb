class AddOwnerToAppPerfil < ActiveRecord::Migration[5.2]
  def change
    add_column :app_perfiles, :o_clss, :string
    add_index :app_perfiles, :o_clss
    add_column :app_perfiles, :o_id, :integer
    add_index :app_perfiles, :o_id
  end
end
