class RemoveAsesoriaFields < ActiveRecord::Migration[8.0]
  def change
    remove_column :tar_servicios, :tipo_asesoria_id, :integer
    remove_column :tar_servicios, :codigo, :string
    remove_column :asesorias, :tipo_asesoria_id, :integer
    remove_column :asesorias, :pendiente, :boolean
    remove_column :asesorias, :urgente, :boolean
  end
end
