class DropLglFiles < ActiveRecord::Migration[8.0]
  def change
   drop_table :lgl_leyes
   drop_table :lgl_repositorios
   drop_table :lgl_n_empleados
  end
end
