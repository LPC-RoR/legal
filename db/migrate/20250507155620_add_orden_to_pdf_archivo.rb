class AddOrdenToPdfArchivo < ActiveRecord::Migration[8.0]
  def change
    add_column :pdf_archivos, :orden, :integer
    add_index :pdf_archivos, :orden
  end
end
