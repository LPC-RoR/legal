class CreateDtCriterioMultas < ActiveRecord::Migration[5.2]
  def change
    create_table :dt_criterio_multas do |t|
      t.integer :dt_tabla_multa_id
      t.integer :orden
      t.decimal :monto
      t.string :unidad
      t.string :dt_criterio_multa

      t.timestamps
    end
    add_index :dt_criterio_multas, :dt_tabla_multa_id
    add_index :dt_criterio_multas, :orden
  end
end
