class CreateCalDias < ActiveRecord::Migration[5.2]
  def change
    create_table :cal_dias do |t|
      t.integer :cal_dia
      t.integer :cal_mes_id

      t.timestamps
    end
    add_index :cal_dias, :cal_dia
    add_index :cal_dias, :cal_mes_id
  end
end
