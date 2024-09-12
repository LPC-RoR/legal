class AddNombreToRepArchivo < ActiveRecord::Migration[7.1]
  def change
    add_column :rep_archivos, :nombre, :string
  end
end
