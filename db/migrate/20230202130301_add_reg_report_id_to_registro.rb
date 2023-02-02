class AddRegReportIdToRegistro < ActiveRecord::Migration[5.2]
  def change
    add_column :registros, :reg_reporte_id, :integer
    add_index :registros, :reg_reporte_id
  end
end
