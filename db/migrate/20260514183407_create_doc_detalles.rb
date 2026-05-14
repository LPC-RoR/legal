class CreateDocDetalles < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_detalles do |t|
      t.integer :doc_emitido_id
      t.string :ownr_type
      t.integer :ownr_id
      t.string :tipo_detalle
      t.date :fecha_uf
      t.string :glosa
      t.decimal :monto

      t.timestamps
    end
    add_index :doc_detalles, :doc_emitido_id
    add_index :doc_detalles, :ownr_type
    add_index :doc_detalles, :ownr_id
    add_index :doc_detalles, :tipo_detalle
  end
end
