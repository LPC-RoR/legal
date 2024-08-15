class AddProcedimientoIdToTarea < ActiveRecord::Migration[7.1]
  def change
    add_column :tareas, :procedimiento_id, :integer
    add_column :tareas, :detalle, :text
    add_index :tareas, :procedimiento_id
  end
end
