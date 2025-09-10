class AddCdgToPdfRegistro < ActiveRecord::Migration[8.0]
  def change
    add_column :pdf_registros, :cdg, :string
    add_index :pdf_registros, :cdg
  end
end
