class AddAutorToBlgArticulo < ActiveRecord::Migration[5.2]
  def change
    add_column :blg_articulos, :autor, :string
  end
end
