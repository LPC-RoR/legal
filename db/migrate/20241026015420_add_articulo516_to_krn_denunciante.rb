class AddArticulo516ToKrnDenunciante < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denunciantes, :articulo_516, :boolean
    add_column :krn_denunciados, :articulo_516, :boolean
  end
end
