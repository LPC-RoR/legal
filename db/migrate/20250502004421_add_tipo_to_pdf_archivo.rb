class AddTipoToPdfArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :pdf_archivos, :tipo, :string
    add_index :pdf_archivos, :tipo
  end
end
