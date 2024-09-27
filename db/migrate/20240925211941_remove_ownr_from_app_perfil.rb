class RemoveOwnrFromAppPerfil < ActiveRecord::Migration[7.1]
  def change
    remove_index :app_perfiles, :o_clss
    remove_column :app_perfiles, :o_clss, :string
    remove_index :app_perfiles, :o_id
    remove_column :app_perfiles, :o_id, :integer
  end
end
