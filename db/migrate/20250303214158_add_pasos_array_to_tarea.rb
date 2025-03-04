class AddPasosArrayToTarea < ActiveRecord::Migration[8.0]
  def change
    add_column :tareas, :pasos_array, :string
  end
end
