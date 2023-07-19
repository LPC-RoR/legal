class AddImagenToBlgArticulo < ActiveRecord::Migration[5.2]
  def change
    add_column :blg_articulos, :imagen, :string
  end
end
