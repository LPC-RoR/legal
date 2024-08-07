class CreateDenuncias < ActiveRecord::Migration[7.1]
  def change
    create_table :denuncias do |t|
      t.integer :empresa_id
      t.integer :alcance_denuncia_id
      t.integer :motivo_denuncia_id
      t.integer :receptor_denuncia_id
      t.integer :investigador_id
      t.datetime :fecha_hora
      t.string :empresa_receptora
      t.string :empresa_denunciante
      t.string :rut_empresa_denunciante
      t.string :representante
      t.string :denunciante
      t.string :rut
      t.string :email
      t.string :cargo
      t.string :lugar_trabajo
      t.boolean :denuncia_verbal
      t.boolean :denuncia_presencial
      t.boolean :denunciante_otra_empresa
      t.boolean :denuncia_derivada
      t.string :destino_derivacion
      t.string :causa_derivacion
      t.string :estado

      t.timestamps
    end
    add_index :denuncias, :empresa_id
    add_index :denuncias, :alcance_denuncia_id
    add_index :denuncias, :motivo_denuncia_id
    add_index :denuncias, :receptor_denuncia_id
    add_index :denuncias, :investigador_id
    add_index :denuncias, :fecha_hora
    add_index :denuncias, :denuncia_verbal
    add_index :denuncias, :denuncia_presencial
    add_index :denuncias, :denunciante_otra_empresa
    add_index :denuncias, :denuncia_derivada
    add_index :denuncias, :estado
  end
end
