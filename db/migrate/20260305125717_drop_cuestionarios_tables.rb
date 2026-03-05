class DropCuestionariosTables < ActiveRecord::Migration[8.0]
  def change
   drop_table :k_sesiones
   drop_table :pautas
   drop_table :cuestionarios
   drop_table :preguntas
   drop_table :respuestas
  end
end
