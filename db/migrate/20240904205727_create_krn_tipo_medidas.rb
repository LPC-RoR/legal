class CreateKrnTipoMedidas < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_tipo_medidas do |t|
      t.integer :cliente_id
      t.integer :empresa_id
      t.string :krn_tipo_medida
      t.boolean :denunciante
      t.boolean :denunciado
      t.string :tipo

      t.timestamps
    end
    add_index :krn_tipo_medidas, :cliente_id
    add_index :krn_tipo_medidas, :empresa_id
    add_index :krn_tipo_medidas, :tipo
  end
end
