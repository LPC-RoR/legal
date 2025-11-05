class CreateLglLeyes < ActiveRecord::Migration[8.0]
  def change
    create_table :lgl_leyes do |t|
      t.integer :lgl_repositorio_id
      t.string :cdg
      t.string :nombre

      t.timestamps
    end
    add_index :lgl_leyes, :lgl_repositorio_id
    add_index :lgl_leyes, :cdg
  end
end
