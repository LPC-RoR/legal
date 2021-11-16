class CreateAppDocumentos < ActiveRecord::Migration[5.2]
  def change
    create_table :app_documentos do |t|
      t.string :documento
      t.integer :app_directorio_id
      t.boolean :publico

      t.timestamps
    end
    add_index :app_documentos, :app_directorio_id
  end
end
