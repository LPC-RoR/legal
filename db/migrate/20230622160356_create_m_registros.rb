class CreateMRegistros < ActiveRecord::Migration[5.2]
  def change
    create_table :m_registros do |t|
      t.string :m_registro
      t.integer :orden
      t.integer :m_conciliacion_id
      t.datetime :fecha
      t.string :glosa_banco
      t.string :glosa
      t.string :documento
      t.decimal :monto
      t.string :cargo_abono
      t.decimal :saldo

      t.timestamps
    end
    add_index :m_registros, :m_registro
    add_index :m_registros, :orden
    add_index :m_registros, :m_conciliacion_id
    add_index :m_registros, :fecha
    add_index :m_registros, :cargo_abono
  end
end
