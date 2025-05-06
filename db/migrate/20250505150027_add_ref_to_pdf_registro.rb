class AddRefToPdfRegistro < ActiveRecord::Migration[8.0]
  def change
    add_column :pdf_registros, :ref_type, :string
    add_index :pdf_registros, :ref_type
    add_column :pdf_registros, :ref_id, :integer
    add_index :pdf_registros, :ref_id
  end
end
