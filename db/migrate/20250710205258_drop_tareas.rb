class DropTareas < ActiveRecord::Migration[8.0]
  def change
    drop_table :tareas
  end
end
