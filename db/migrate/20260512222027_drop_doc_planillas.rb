class DropDocPlanillas < ActiveRecord::Migration[8.0]
  def up
    drop_table :doc_emitido_detalles if table_exists?(:doc_emitido_detalles)
  end

  def down
    create_table :doc_emitido_detalles do |t|
      t.references :doc_emitido, foreign_key: true, null: false
      t.integer :item, null: false
      t.string :codigo, limit: 50
      t.string :descripcion, limit: 255, null: false
      t.decimal :cantidad, precision: 12, scale: 2, null: false
      t.decimal :precio_unitario, precision: 15, scale: 2, null: false
      t.decimal :descuento_pct, precision: 5, scale: 2
      t.decimal :descuento_monto, precision: 15, scale: 2
      t.string :cod_impuesto_adic, limit: 10
      t.decimal :monto_item, precision: 15, scale: 2, null: false
      t.timestamps
    end
    add_index :doc_emitido_detalles, [:doc_emitido_id, :item], unique: true
  end
end
