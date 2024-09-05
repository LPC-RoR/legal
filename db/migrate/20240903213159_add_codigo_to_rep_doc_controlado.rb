class AddCodigoToRepDocControlado < ActiveRecord::Migration[7.1]
  def change
    add_column :rep_doc_controlados, :codigo, :string
    add_index :rep_doc_controlados, :codigo
  end
end
