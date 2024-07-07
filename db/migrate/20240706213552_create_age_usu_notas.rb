class CreateAgeUsuNotas < ActiveRecord::Migration[7.1]
  def change
    create_table :age_usu_notas do |t|
      t.integer :age_usuario_id
      t.integer :nota_id

      t.timestamps
    end
    add_index :age_usu_notas, :age_usuario_id
    add_index :age_usu_notas, :nota_id
  end
end
