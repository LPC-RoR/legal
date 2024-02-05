class AddDtFechaToCalDia < ActiveRecord::Migration[5.2]
  def change
    add_column :cal_dias, :dt_fecha, :datetime
    add_index :cal_dias, :dt_fecha
  end
end
