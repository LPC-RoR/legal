class AddRegReporteIdToRegistro < ActiveRecord::Migration[5.2]
  def change
    add_column :registros, :reporte_id, :integer
    add_index :registros, :reporte_id
  end
end
