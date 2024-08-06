class CreateDenunciados < ActiveRecord::Migration[7.1]
  def change
    create_table :denunciados do |t|
      t.integer :denuncia_id
      t.integer :tipo_denunciado_id
      t.string :denunciado
      t.string :vinculo
      t.string :rut
      t.string :cargo
      t.string :lugar_trabajo
      t.string :email

      t.timestamps
    end
    add_index :denunciados, :denuncia_id
    add_index :denunciados, :tipo_denunciado_id
  end
end
