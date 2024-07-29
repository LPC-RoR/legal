class CreateHPreguntas < ActiveRecord::Migration[7.1]
  def change
    create_table :h_preguntas do |t|
      t.string :codigo
      t.string :h_pregunta
      t.text :respuesta
      t.string :lnk_txt
      t.string :lnk

      t.timestamps
    end
    add_index :h_preguntas, :codigo
  end
end
