class CreateAntecedentes < ActiveRecord::Migration[5.2]
  def change
    create_table :antecedentes do |t|
      t.string :hecho
      t.string :riesgo
      t.string :ventaja
      t.text :cita
      t.integer :orden
      t.integer :causa_id

      t.timestamps
    end
    add_index :antecedentes, :orden
    add_index :antecedentes, :causa_id
  end
end
