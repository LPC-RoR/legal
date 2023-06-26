class CreateAppControlDocumentos < ActiveRecord::Migration[5.2]
  def change
    create_table :app_control_documentos do |t|
      t.string :app_control_documento
      t.string :existencia
      t.string :vencimiento
      t.string :ownr_class
      t.integer :owner_id

      t.timestamps
    end
    add_index :app_control_documentos, :app_control_documento
    add_index :app_control_documentos, :existencia
    add_index :app_control_documentos, :vencimiento
    add_index :app_control_documentos, :ownr_class
    add_index :app_control_documentos, :owner_id
  end
end
