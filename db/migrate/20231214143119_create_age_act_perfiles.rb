class CreateAgeActPerfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :age_act_perfiles do |t|
      t.integer :app_perfil_id
      t.integer :age_actividad_id

      t.timestamps
    end
    add_index :age_act_perfiles, :app_perfil_id
    add_index :age_act_perfiles, :age_actividad_id
  end
end
