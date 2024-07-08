class AddSinFechaGestionToNota < ActiveRecord::Migration[7.1]
  def change
    add_column :notas, :sin_fecha_gestion, :boolean
  end
end
