class CreateActMetadatas < ActiveRecord::Migration[8.0]
  def change
    create_table :act_metadatas do |t|
      t.references :act_archivo, null: false, foreign_key: { to_table: :act_archivos }
      t.string :act_metadata, null: false
      t.jsonb :metadata, default: {}, null: false
      
      t.timestamps
    end
    
    add_index :act_metadatas, [:act_archivo_id, :act_metadata], unique: true, name: 'idx_act_metadatas_unique_codigo'
    add_index :act_metadatas, :metadata, using: :gin
  end
end
