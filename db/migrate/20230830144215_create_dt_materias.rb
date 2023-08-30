class CreateDtMaterias < ActiveRecord::Migration[5.2]
  def change
    create_table :dt_materias do |t|
      t.string :dt_materia
      t.integer :capitulo

      t.timestamps
    end
    add_index :dt_materias, :capitulo
  end
end
