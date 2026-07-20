class AddEstadosAasToAsesoria < ActiveRecord::Migration[8.0]
  def change
    add_column :asesorias, :estado_operativo, :string
    add_index :asesorias, :estado_operativo
    add_column :asesorias, :estado_financiero, :string
    add_index :asesorias, :estado_financiero
  end
end
