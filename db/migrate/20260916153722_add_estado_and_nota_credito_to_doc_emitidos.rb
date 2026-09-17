class AddEstadoAndNotaCreditoToDocEmitidos < ActiveRecord::Migration[8.0]
  def change
    add_column :doc_emitidos, :estado, :integer, default: 0, null: false
    add_index  :doc_emitidos, :estado

    # Self-reference: documento anulado -> nota de crédito que lo anula
    add_reference :doc_emitidos, :nota_credito,
                  foreign_key: { to_table: :doc_emitidos },
                  null: true

    # Folio denormalizado como respaldo histórico (se copia al anular)
    add_column :doc_emitidos, :nota_credito_folio, :string
  end
end
