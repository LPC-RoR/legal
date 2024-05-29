class AddEspecialToAgeActividad < ActiveRecord::Migration[5.2]
  def change
    add_column :age_actividades, :audiencia_especial, :string
  end
end
