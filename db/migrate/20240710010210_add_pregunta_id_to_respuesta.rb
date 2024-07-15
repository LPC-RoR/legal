class AddPreguntaIdToRespuesta < ActiveRecord::Migration[7.1]
  def change
    add_column :respuestas, :pregunta_id, :integer
    add_index :respuestas, :pregunta_id
  end
end
