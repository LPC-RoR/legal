class CreateCalMesSems < ActiveRecord::Migration[5.2]
  def change
    create_table :cal_mes_sems do |t|
      t.integer :cal_mes_id
      t.integer :cal_semana_id

      t.timestamps
    end
    add_index :cal_mes_sems, :cal_mes_id
    add_index :cal_mes_sems, :cal_semana_id
  end
end
