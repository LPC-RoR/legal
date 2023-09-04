class AddPorcentajesToDtTablaMulta < ActiveRecord::Migration[5.2]
  def change
    add_column :dt_tabla_multas, :p100_leve, :decimal
    add_column :dt_tabla_multas, :p100_grave, :decimal
    add_column :dt_tabla_multas, :p100_gravisima, :decimal
  end
end
