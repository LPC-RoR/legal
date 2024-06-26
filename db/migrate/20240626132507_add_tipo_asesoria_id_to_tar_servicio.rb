class AddTipoAsesoriaIdToTarServicio < ActiveRecord::Migration[7.1]
  def change
    add_column :tar_servicios, :tipo_asesoria_id, :integer
    add_index :tar_servicios, :tipo_asesoria_id
  end
end
