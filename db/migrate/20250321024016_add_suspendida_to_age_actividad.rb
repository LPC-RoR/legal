class AddSuspendidaToAgeActividad < ActiveRecord::Migration[8.0]
  def change
    add_column :age_actividades, :suspendida, :boolean
  end
end
