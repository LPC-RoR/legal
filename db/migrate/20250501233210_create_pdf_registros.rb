class CreatePdfRegistros < ActiveRecord::Migration[8.0]
  def change
    create_table :pdf_registros do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.integer :pdf_archivo_id

      t.timestamps
    end
    add_index :pdf_registros, :ownr_type
    add_index :pdf_registros, :ownr_id
    add_index :pdf_registros, :pdf_archivo_id
  end
end
