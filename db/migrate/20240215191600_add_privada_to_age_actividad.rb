class AddPrivadaToAgeActividad < ActiveRecord::Migration[5.2]
  def change
    add_column :age_actividades, :privada, :boolean
    add_index :age_actividades, :privada
  end
end
