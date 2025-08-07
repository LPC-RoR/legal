class AddTareaConPlazoToNota < ActiveRecord::Migration[8.0]
  def change
    add_column :notas, :tarea_con_plazo, :boolean
  end
end
