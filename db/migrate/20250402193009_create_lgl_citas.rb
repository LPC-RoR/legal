class CreateLglCitas < ActiveRecord::Migration[8.0]
  def change
    create_table :lgl_citas do |t|
      t.integer :lgl_parrafo_id
      t.integer :orden
      t.string :codigo
      t.string :lgl_cita
      t.string :referencia

      t.timestamps
    end
    add_index :lgl_citas, :lgl_parrafo_id
    add_index :lgl_citas, :orden
    add_index :lgl_citas, :codigo
  end
end
