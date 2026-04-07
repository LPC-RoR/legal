class CreateKrnTexto < ActiveRecord::Migration[8.0]
  def change
    create_table :krn_textos do |t|
      t.references :krn_denuncia, null: false, foreign_key: true
      t.string :codigo, null: false
      
      # NOTA: El campo 'texto' ya no es necesario si usas ActionText
      # porque el contenido se guarda en la tabla action_text_rich_texts
      # Pero si quieres mantenerlo como respaldo:
      # t.text :texto_legacy
      
      t.timestamps
    end
    
    # Índice para búsquedas por código
    add_index :krn_textos, [:krn_denuncia_id, :codigo], unique: true
  end
end
