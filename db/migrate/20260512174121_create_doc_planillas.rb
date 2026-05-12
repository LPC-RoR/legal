class CreateDocPlanillas < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_planillas do |t|
      t.string :nombre_original, null: false
      t.string :tipo, default: 'emitidos', null: false
      t.integer :mes, null: false
      t.integer :anio, null: false
      t.string :estado, default: 'pendiente', null: false
      t.integer :total_documentos, default: 0
      t.integer :documentos_cargados, default: 0
      t.text :errores
      t.datetime :procesado

      t.timestamps
    end

    add_index :doc_planillas, [:anio, :mes, :created_at]
    add_index :doc_planillas, :estado
  end
end