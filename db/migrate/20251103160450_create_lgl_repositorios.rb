class CreateLglRepositorios < ActiveRecord::Migration[8.0]
  def change
    create_table :lgl_repositorios do |t|
      t.string :dcg
      t.string :nombre

      t.timestamps
    end
    add_index :lgl_repositorios, :dcg
  end
end
