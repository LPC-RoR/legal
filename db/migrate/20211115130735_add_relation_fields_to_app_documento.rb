class AddRelationFieldsToAppDocumento < ActiveRecord::Migration[5.2]
  def change
    add_column :app_documentos, :owner_class, :string
    add_index :app_documentos, :owner_class
    add_column :app_documentos, :owner_id, :integer
    add_index :app_documentos, :owner_id
  end
end
