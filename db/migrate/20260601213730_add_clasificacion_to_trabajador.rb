class AddClasificacionToTrabajador < ActiveRecord::Migration[8.0]
  def change
    add_column :trabajadores, :clasificacion, :string
  end
end
