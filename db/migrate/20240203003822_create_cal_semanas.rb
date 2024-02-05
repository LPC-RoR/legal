class CreateCalSemanas < ActiveRecord::Migration[5.2]
  def change
    create_table :cal_semanas do |t|
      t.integer :cal_semana
      t.integer :cal_mes_id

      t.timestamps
    end
    add_index :cal_semanas, :cal_semana
    add_index :cal_semanas, :cal_mes_id
  end
end
