class AddOwnrToAppDocumento < ActiveRecord::Migration[7.1]
  def change
    add_column :app_documentos, :ownr_type, :string
    add_index :app_documentos, :ownr_type
    add_column :app_documentos, :ownr_id, :integer
    add_index :app_documentos, :ownr_id
  end
end
