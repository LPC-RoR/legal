class CreateDocCartolas < ActiveRecord::Migration[8.0]
  def change
    create_table :doc_cartolas do |t|
      t.references :doc_cuenta, null: false, foreign_key: true
      t.integer :numero_cartola
      t.date :fecha_desde
      t.date :fecha_hasta
      t.decimal :saldo_inicial, precision: 15, scale: 2
      t.decimal :depositos, precision: 15, scale: 2
      t.decimal :otros_abonos, precision: 15, scale: 2
      t.decimal :cheques, precision: 15, scale: 2
      t.decimal :otros_cargos, precision: 15, scale: 2
      t.decimal :impuestos, precision: 15, scale: 2
      t.decimal :saldo_final, precision: 15, scale: 2
      t.decimal :cupo_aprobado, precision: 15, scale: 2
      t.decimal :monto_utilizado, precision: 15, scale: 2
      t.decimal :saldo_disponible, precision: 15, scale: 2

      t.timestamps
    end
  end
end
