class AddPointsToNota < ActiveRecord::Migration[7.1]
  def change
    add_column :notas, :pendiente, :boolean
    add_column :notas, :urgente, :boolean
  end
end
