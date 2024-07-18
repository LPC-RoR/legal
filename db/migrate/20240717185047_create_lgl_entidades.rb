class CreateLglEntidades < ActiveRecord::Migration[7.1]
  def change
    create_table :lgl_entidades do |t|
      t.string :lgl_entidad
      t.string :tipo
      t.string :dependencia

      t.timestamps
    end
    add_index :lgl_entidades, :tipo
  end
end
