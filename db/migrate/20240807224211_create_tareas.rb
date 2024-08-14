class CreateTareas < ActiveRecord::Migration[7.1]
  def change
    create_table :tareas do |t|
      t.integer :orden
      t.string :codigo
      t.string :tarea
      t.string :plazo

      t.timestamps
    end
    add_index :tareas, :orden
    add_index :tareas, :codigo
  end
end
