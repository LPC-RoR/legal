class CreateCalFeriados < ActiveRecord::Migration[5.2]
  def change
    create_table :cal_feriados do |t|
      t.integer :cal_annio_id
      t.datetime :cal_fecha
      t.string :descripcion

      t.timestamps
    end
    add_index :cal_feriados, :cal_annio_id
    add_index :cal_feriados, :cal_fecha
  end
end
