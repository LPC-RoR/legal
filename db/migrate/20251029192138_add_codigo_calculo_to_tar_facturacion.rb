class AddCodigoCalculoToTarFacturacion < ActiveRecord::Migration[8.0]
  def change
    add_column :tar_facturaciones, :codigo_formula, :string
    add_index :tar_facturaciones, :codigo_formula
    add_column :tar_calculos, :codigo_formula, :string
    add_index :tar_calculos, :codigo_formula
  end
end
