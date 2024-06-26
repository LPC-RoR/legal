class CreateParrafos < ActiveRecord::Migration[7.1]
  def change
    create_table :parrafos do |t|
      t.integer :causa_id
      t.integer :seccion_id
      t.integer :orden
      t.text :texto

      t.timestamps
    end
    add_index :parrafos, :causa_id
    add_index :parrafos, :seccion_id
    add_index :parrafos, :orden
  end
end
