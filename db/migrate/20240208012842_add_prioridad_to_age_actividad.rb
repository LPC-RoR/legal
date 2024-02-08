class AddPrioridadToAgeActividad < ActiveRecord::Migration[5.2]
  def change
    add_column :age_actividades, :prioridad, :string
  end
end
