class CreateComDocumentos < ActiveRecord::Migration[8.0]
  def change
    create_table :com_documentos do |t|
      t.string :codigo, null: false
      t.string :titulo, null: false
      t.string :doc_type, null: false   # "contrato", "propuesta", etc.
      t.date :issued_on

      t.timestamps
    end
    add_index :com_documentos, :codigo
    add_index :com_documentos, :doc_type
    add_index :com_documentos, :issued_on
  end
end
