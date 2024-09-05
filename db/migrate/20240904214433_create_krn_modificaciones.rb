class CreateKrnModificaciones < ActiveRecord::Migration[7.1]
  def change
    create_table :krn_modificaciones do |t|
      t.integer :krn_lst_modificacion_id
      t.integer :krn_medida_id
      t.text :detalle

      t.timestamps
    end
    add_index :krn_modificaciones, :krn_lst_modificacion_id
    add_index :krn_modificaciones, :krn_medida_id
  end
end
