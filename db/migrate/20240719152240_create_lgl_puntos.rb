class CreateLglPuntos < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_puntos do |t|
      t.integer :orden
      t.integer :lgl_parrafo_id
      t.string :lgl_punto
      t.text :cita

      t.timestamps
    end
    add_index :lgl_puntos, :orden
    add_index :lgl_puntos, :lgl_parrafo_id
  end
end
