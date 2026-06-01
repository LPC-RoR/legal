class CreateDocCierres < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_cierres do |t|
      t.date :fecha_inicio
      t.date :fecha_termino
      t.decimal :saldo_inicial
      t.decimal :saldo_final
      t.string :encabezado

      t.timestamps
    end
  end
end
