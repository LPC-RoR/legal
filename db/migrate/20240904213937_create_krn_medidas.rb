class CreateKrnMedidas < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_medidas do |t|
      t.integer :krn_lst_medida_id
      t.integer :krn_tipo_medida_id
      t.string :krn_medida
      t.text :detalle

      t.timestamps
    end
    add_index :krn_medidas, :krn_lst_medida_id
    add_index :krn_medidas, :krn_tipo_medida_id
  end
end
