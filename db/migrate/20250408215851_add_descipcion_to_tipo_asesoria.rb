class AddDescipcionToTipoAsesoria < ActiveRecord::Migration[8.0]
  def change
    add_column :tipo_asesorias, :descipcion, :string
    add_column :tipo_cargos, :descipcion, :string
  end
end
