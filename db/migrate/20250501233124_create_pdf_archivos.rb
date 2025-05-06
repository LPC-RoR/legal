class CreatePdfArchivos < ActiveRecord::Migration[8.0]
  def change
    create_table :pdf_archivos do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.string :codigo
      t.string :nombre
      t.string :modelos

      t.timestamps
    end
    add_index :pdf_archivos, :ownr_type
    add_index :pdf_archivos, :ownr_id
    add_index :pdf_archivos, :codigo
  end
end
