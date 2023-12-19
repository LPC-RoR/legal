class CreateTemas < ActiveRecord::Migration[5.2]
  def change
    create_table :temas do |t|
      t.integer :causa_id
      t.integer :orden
      t.string :tema
      t.text :descripcion

      t.timestamps
    end
    add_index :temas, :causa_id
    add_index :temas, :orden
  end
end
