class CreateAgeUsuActs < ActiveRecord::Migration[5.2]
  def change
    create_table :age_usu_acts do |t|
      t.integer :age_usuario_id
      t.integer :age_actividad_id

      t.timestamps
    end
    add_index :age_usu_acts, :age_usuario_id
    add_index :age_usu_acts, :age_actividad_id
  end
end
