class RemovePasosArrayFromTarea < ActiveRecord::Migration[8.0]
  def change
    remove_column :tareas, :pasos_array, :string
  end
end
