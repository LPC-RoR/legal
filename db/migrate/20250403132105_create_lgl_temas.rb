class CreateLglTemas < ActiveRecord::Migration[8.0]
  def change
    create_table :lgl_temas do |t|
      t.string :ownr_type
      t.integer :ownr_id
      t.integer :orden
      t.string :codigo
      t.string :lgl_tema
      t.boolean :heredado

      t.timestamps
    end
    add_index :lgl_temas, :ownr_type
    add_index :lgl_temas, :ownr_id
    add_index :lgl_temas, :codigo
    add_index :lgl_temas, :orden
  end
end
