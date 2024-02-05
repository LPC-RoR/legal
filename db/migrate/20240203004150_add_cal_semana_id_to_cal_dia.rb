class AddCalSemanaIdToCalDia < ActiveRecord::Migration[5.2]
  def change
    add_column :cal_dias, :cal_semana_id, :integer
    add_index :cal_dias, :cal_semana_id
  end
end
