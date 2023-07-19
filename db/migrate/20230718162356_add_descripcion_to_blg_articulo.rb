class AddDescripcionToBlgArticulo < ActiveRecord::Migration[5.2]
  def change
    add_column :blg_articulos, :descripcion, :text
  end
end
