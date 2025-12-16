class DropTiposAudienciasFiles < ActiveRecord::Migration[8.0]
  def change
   drop_table :audiencias
   drop_table :tipo_causas
  end
end
