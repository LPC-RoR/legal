class AddEstadoToRegReporte < ActiveRecord::Migration[5.2]
  def change
    add_column :reg_reportes, :estado, :string
    add_index :reg_reportes, :estado
  end
end
