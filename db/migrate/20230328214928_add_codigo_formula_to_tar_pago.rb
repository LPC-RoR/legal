class AddCodigoFormulaToTarPago < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_pagos, :codigo_formula, :string
    add_index :tar_pagos, :codigo_formula
  end
end
