class CreatePreguntas < ActiveRecord::Migration[7.1]
  def change
    create_table :preguntas do |t|
      t.integer :orden
      t.integer :cuestionario_id
      t.string :pregunta
      t.string :tipo
      t.string :referencia

      t.timestamps
    end
    add_index :preguntas, :orden
    add_index :preguntas, :cuestionario_id
  end
end
