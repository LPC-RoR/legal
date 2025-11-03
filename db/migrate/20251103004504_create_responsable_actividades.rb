class CreateResponsableActividades < ActiveRecord::Migration[8.0]
  def change
    create_table :responsable_actividades do |t|
      t.references :age_actividad, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
