class AddCodigoToKrnDerivacion < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_derivaciones, :codigo, :string
    add_index :krn_derivaciones, :codigo
  end
end
