class AddMonedaToDtTablaMulta < ActiveRecord::Migration[5.2]
  def change
    add_column :dt_tabla_multas, :moneda, :string
  end
end
