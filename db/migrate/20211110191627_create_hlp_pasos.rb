class CreateHlpPasos < ActiveRecord::Migration[5.2]
  def change
    create_table :hlp_pasos do |t|
      t.integer :orden
      t.string :paso
      t.text :detalle
      t.integer :hlp_tutorial_id

      t.timestamps
    end
    add_index :hlp_pasos, :orden
    add_index :hlp_pasos, :hlp_tutorial_id
  end
end
