class ChangeCalFeriadoCalFechaToDate < ActiveRecord::Migration[8.0]
  def up
    change_column :cal_feriados, :cal_fecha, :date
  end
  
  def down
    change_column :cal_feriados, :cal_fecha, :datetime
  end
end
