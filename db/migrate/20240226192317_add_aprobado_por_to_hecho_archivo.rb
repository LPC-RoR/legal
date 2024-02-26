class AddAprobadoPorToHechoArchivo < ActiveRecord::Migration[5.2]
  def change
    add_column :hecho_archivos, :aprobado_por, :string
  end
end
