class AddCodigoToTarFormula < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_formulas, :codigo, :string
    add_index :tar_formulas, :codigo
  end
end
