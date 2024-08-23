class CreateKrnDenunciantes < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_denunciantes do |t|
      t.integer :denuncia_id
      t.integer :empresa_externa_id
      t.string :rut
      t.string :nombre
      t.string :cargo
      t.string :lugar_trabajo
      t.string :email
      t.string :email_ok
      t.boolean :articulo_4_1

      t.timestamps
    end
    add_index :krn_denunciantes, :denuncia_id
    add_index :krn_denunciantes, :empresa_externa_id
    add_index :krn_denunciantes, :rut
  end
end
