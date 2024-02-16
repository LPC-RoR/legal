class CreateAgeLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :age_logs do |t|
      t.datetime :fecha
      t.string :age_actividad
      t.integer :age_actividad_id

      t.timestamps
    end
    add_index :age_logs, :age_actividad_id
  end
end
