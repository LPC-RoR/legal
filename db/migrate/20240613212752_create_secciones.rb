class CreateSecciones < ActiveRecord::Migration[7.1]
  def change
    create_table :secciones do |t|
      t.integer :causa_id
      t.integer :orden
      t.string :seccion
      t.text :texto

      t.timestamps
    end
    add_index :secciones, :causa_id
    add_index :secciones, :orden
  end
end
