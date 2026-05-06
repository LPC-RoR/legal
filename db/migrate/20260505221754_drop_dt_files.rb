class DropDtFiles < ActiveRecord::Migration[8.0]
  def change
   drop_table :dt_infracciones
   drop_table :dt_materias
   drop_table :dt_multas
   drop_table :dt_tabla_multas
   drop_table :dt_tramos
  end
end
