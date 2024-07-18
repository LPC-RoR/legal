class CreateLglDatos < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_datos do |t|
      t.integer :lgl_parrafo_id
      t.integer :orden
      t.string :lgl_dato
      t.text :cita

      t.timestamps
    end
    add_index :lgl_datos, :lgl_parrafo_id
    add_index :lgl_datos, :orden
  end
end
