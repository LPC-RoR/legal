class DropSrvcsTabls < ActiveRecord::Migration[8.0]
  def change
    drop_table :tipo_asesorias
    drop_table :cargos
    drop_table :tipo_cargos
  end
end
