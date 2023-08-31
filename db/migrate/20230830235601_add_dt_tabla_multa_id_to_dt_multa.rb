class AddDtTablaMultaIdToDtMulta < ActiveRecord::Migration[5.2]
  def change
    add_column :dt_multas, :dt_tabla_multa_id, :integer
    add_index :dt_multas, :dt_tabla_multa_id
  end
end
