class AddAprobacionConDetalleToTarTarifa < ActiveRecord::Migration[8.0]
  def change
    add_column :tar_tarifas, :aprobacion_con_detalle, :boolean
    add_index :tar_tarifas, :aprobacion_con_detalle
  end
end
