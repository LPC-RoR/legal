class CreateDocTransacciones < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_transacciones do |t|
      t.references :doc_cartola, null: false, foreign_key: true
      t.references :doc_cuenta, null: false, foreign_key: true
      t.decimal :monto, precision: 15, scale: 2, null: false
      t.string :descripcion, null: false
      t.string :descripcion_rut # El prefijo numérico extraído de la descripción
      t.date :fecha
      t.string :numero_documento
      t.string :sucursal
      t.string :tipo_movimiento # 'C' = Cargo, 'A' = Abono
      t.references :relacionable, polymorphic: true, null: true

      t.timestamps
    end

    add_index :doc_transacciones, [:doc_cartola_id, :fecha]
    add_index :doc_transacciones, :descripcion_rut
    add_index :doc_transacciones, [:relacionable_type, :relacionable_id]
  end
end
