class AddCodigoToControlDocumento < ActiveRecord::Migration[7.1]
  def change
    add_column :control_documentos, :codigo, :string
    add_index :control_documentos, :codigo
  end
end
