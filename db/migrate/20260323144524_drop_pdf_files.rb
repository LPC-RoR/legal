class DropPdfFiles < ActiveRecord::Migration[8.0]
  def change
   drop_table :pdf_archivos
   drop_table :pdf_registros
  end
end
