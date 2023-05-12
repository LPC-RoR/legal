class AddDespliegueToTarComentario < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_comentarios, :despliegue, :string
  end
end
