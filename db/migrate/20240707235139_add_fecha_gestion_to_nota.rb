class AddFechaGestionToNota < ActiveRecord::Migration[7.1]
  def change
    add_column :notas, :fecha_gestion, :datetime
  end
end
