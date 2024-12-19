class DropHFiles < ActiveRecord::Migration[7.1]
  def change
    drop_table :h_textos
    drop_table :h_preguntas
    drop_table :h_imagenes
  end
end
