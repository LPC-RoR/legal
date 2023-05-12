class AddMonedaToTarComentario < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_comentarios, :moneda, :string
  end
end
