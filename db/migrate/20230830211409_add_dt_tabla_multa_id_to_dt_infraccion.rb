class AddDtTablaMultaIdToDtInfraccion < ActiveRecord::Migration[5.2]
  def change
    add_column :dt_infracciones, :dt_tabla_multa_id, :integer
    add_index :dt_infracciones, :dt_tabla_multa_id
  end
end
