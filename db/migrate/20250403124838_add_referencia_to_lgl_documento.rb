class AddReferenciaToLglDocumento < ActiveRecord::Migration[8.0]
  def change
    add_column :lgl_documentos, :referencia, :string
    add_column :lgl_parrafos, :referencia, :string
  end
end
