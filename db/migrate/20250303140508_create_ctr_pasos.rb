class CreateCtrPasos < ActiveRecord::Migration[8.0]
  def change
    create_table :ctr_pasos do |t|
      t.integer :orden
      t.integer :tarea_id
      t.string :codigo
      t.string :glosa
      t.boolean :rght

      t.timestamps
    end
    add_index :ctr_pasos, :orden
    add_index :ctr_pasos, :tarea_id
    add_index :ctr_pasos, :codigo
  end
end
