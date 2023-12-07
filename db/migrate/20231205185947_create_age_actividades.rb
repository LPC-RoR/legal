class CreateAgeActividades < ActiveRecord::Migration[5.2]
  def change
    create_table :age_actividades do |t|
      t.string :age_actividad
      t.string :tipo
      t.integer :app_perfil_id
      t.string :owner_class
      t.integer :owner_id
      t.string :estado
      t.datetime :fecha

      t.timestamps
    end
    add_index :age_actividades, :app_perfil_id
    add_index :age_actividades, :owner_class
    add_index :age_actividades, :owner_id
    add_index :age_actividades, :estado
    add_index :age_actividades, :fecha
  end
end
