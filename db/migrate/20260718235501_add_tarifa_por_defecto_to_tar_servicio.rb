class AddTarifaPorDefectoToTarServicio < ActiveRecord::Migration[8.0]
  def change
    add_column :tar_servicios, :tarifa_por_defecto, :boolean
    add_column :tar_servicios, :tarifa_variable, :boolean
    add_column :tar_servicios, :servicio_base, :boolean
  end
end
