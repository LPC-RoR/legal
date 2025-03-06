class CambiaTipoDeInvestigacionLocal < ActiveRecord::Migration[8.0]
  def change
    change_column :krn_denuncias, :investigacion_local, :boolean, using: 'investigacion_local::boolean'
  end
end
