class CreateHechos < ActiveRecord::Migration[5.2]
  def change
    create_table :hechos do |t|
      t.integer :tema_id
      t.integer :orden
      t.string :hecho
      t.text :cita
      t.string :archivo

      t.timestamps
    end
    add_index :hechos, :tema_id
    add_index :hechos, :orden
  end
end
