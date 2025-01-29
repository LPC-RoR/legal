class AddOwnrToAppArchivo < ActiveRecord::Migration[7.1]
  def change
    add_column :app_archivos, :ownr_type, :string
    add_index :app_archivos, :ownr_type
    add_column :app_archivos, :ownr_id, :integer
    add_index :app_archivos, :ownr_id
  end
end
