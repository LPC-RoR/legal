class DropBlgFiles < ActiveRecord::Migration[7.1]
  def change
    drop_table :blg_temas
    drop_table :blg_articulos
    drop_table :blg_imagenes
  end
end
