class CreateSlides < ActiveRecord::Migration[8.0]
  def change
    create_table :slides do |t|
      t.integer :orden
      t.boolean :desactivar
      t.string :nombre
      t.text :txt

      t.timestamps
    end
    add_index :slides, :orden
  end
end
