class CreateAgeAntecedentes < ActiveRecord::Migration[5.2]
  def change
    create_table :age_antecedentes do |t|
      t.integer :orden
      t.text :age_antecedente
      t.integer :age_actividad_id

      t.timestamps
    end
    add_index :age_antecedentes, :orden
    add_index :age_antecedentes, :age_actividad_id
  end
end
