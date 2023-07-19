class AddImagenToBlgTema < ActiveRecord::Migration[5.2]
  def change
    add_column :blg_temas, :imagen, :string
  end
end
