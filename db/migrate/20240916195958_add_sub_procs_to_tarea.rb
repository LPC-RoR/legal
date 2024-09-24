class AddSubProcsToTarea < ActiveRecord::Migration[7.1]
  def change
    add_column :tareas, :sub_procs, :string
    add_index :tareas, :sub_procs
  end
end
