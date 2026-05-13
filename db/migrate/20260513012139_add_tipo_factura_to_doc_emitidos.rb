class AddTipoFacturaToDocEmitidos < ActiveRecord::Migration[8.0]
  def change
    add_column :doc_emitidos, :tipo_factura, :string
  end
end
