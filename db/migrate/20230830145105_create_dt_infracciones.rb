class CreateDtInfracciones < ActiveRecord::Migration[5.2]
  def change
    create_table :dt_infracciones do |t|
      t.string :codigo
      t.string :normas
      t.string :dt_infraccion
      t.text :tipificacion
      t.string :criterios
      t.integer :dt_materia_id

      t.timestamps
    end
    add_index :dt_infracciones, :dt_materia_id
  end
end
