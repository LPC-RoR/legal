class CreateCausaHechos < ActiveRecord::Migration[5.2]
  def change
    create_table :causa_hechos do |t|
      t.integer :causa_id
      t.integer :hecho_id
      t.integer :orden
      t.string :st_contestación
      t.string :st_preparatoria
      t.string :st_juicio

      t.timestamps
    end
    add_index :causa_hechos, :causa_id
    add_index :causa_hechos, :hecho_id
    add_index :causa_hechos, :orden
  end
end
