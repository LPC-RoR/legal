class CreateLglRecursos < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_recursos do |t|
      t.string :lgl_recurso
      t.string :tipo

      t.timestamps
    end
    add_index :lgl_recursos, :tipo
  end
end
