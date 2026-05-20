class AddCodigoFormulaToDocDetalle < ActiveRecord::Migration[8.0]
  def change
    add_column :doc_detalles, :codigo_formula, :string
    add_index :doc_detalles, :codigo_formula
  end
end
