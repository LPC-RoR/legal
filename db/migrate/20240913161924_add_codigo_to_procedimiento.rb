class AddCodigoToProcedimiento < ActiveRecord::Migration[7.1]
  def change
    add_column :procedimientos, :codigo, :string
    add_index :procedimientos, :codigo
  end
end
