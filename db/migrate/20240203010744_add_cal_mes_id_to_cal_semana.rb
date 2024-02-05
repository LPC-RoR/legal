class AddCalMesIdToCalSemana < ActiveRecord::Migration[5.2]
  def change
    add_column :cal_semanas, :cal_mes_id, :integer
    add_index :cal_semanas, :cal_mes_id
  end
end
