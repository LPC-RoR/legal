class AddTipoToCalFeriado < ActiveRecord::Migration[7.1]
  def change
    add_column :cal_feriados, :tipo, :string
    add_index :cal_feriados, :tipo

    remove_column :cal_feriados, :cal_annio_id, :integer

    drop_table :cal_annios
    drop_table :cal_dias
    drop_table :cal_mes_sems
    drop_table :cal_meses
    drop_table :cal_semanas
  end
end
