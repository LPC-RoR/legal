class AddOwnrToControlDocumento < ActiveRecord::Migration[7.1]
  def change
    add_column :control_documentos, :ownr_type, :string
    add_index :control_documentos, :ownr_type
    add_column :control_documentos, :ownr_id, :integer
    add_index :control_documentos, :ownr_id
  end
end
