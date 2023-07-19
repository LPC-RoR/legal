class AddDescripcionToBlgTema < ActiveRecord::Migration[5.2]
  def change
    add_column :blg_temas, :descripcion, :text
  end
end
