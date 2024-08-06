class CreateDenuncias < ActiveRecord::Migration[7.1]
  def change
    create_table :denuncias do |t|
      t.integer :empresa_id
      t.integer :tipo_denuncia_id
      t.datetime :fecha_hora
      t.string :denunciante
      t.string :rut
      t.string :cargo
      t.string :lugar_trabajo
      t.boolean :verbal_escrita
      t.boolean :empleador_dt_tercero
      t.boolean :presencial_electronica
      t.string :email

      t.timestamps
    end
    add_index :denuncias, :empresa_id
    add_index :denuncias, :tipo_denuncia_id
    add_index :denuncias, :fecha_hora
    add_index :denuncias, :verbal_escrita
    add_index :denuncias, :empleador_dt_tercero
    add_index :denuncias, :presencial_electronica
  end
end
