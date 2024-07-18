class CreateLglDocumentos < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_documentos do |t|
      t.string :lgl_documento
      t.string :tipo
      t.string :archivo

      t.timestamps
    end
    add_index :lgl_documentos, :tipo
  end
end
