class AddTipoAsesoriaIdToAsesoria < ActiveRecord::Migration[5.2]
  def change
    add_column :asesorias, :tipo_asesoria_id, :integer
    add_index :asesorias, :tipo_asesoria_id
  end
end
