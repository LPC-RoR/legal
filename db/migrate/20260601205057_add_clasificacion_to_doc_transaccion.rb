class AddClasificacionToDocTransaccion < ActiveRecord::Migration[8.0]
  def change
    add_column :doc_transacciones, :clasificacion, :string
    add_index :doc_transacciones, :clasificacion
  end
end
