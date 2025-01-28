class DropTarifaFiles < ActiveRecord::Migration[7.1]
  def change
    drop_table :tar_detalles
    drop_table :tar_det_cuantia_controles
    drop_table :tar_valores
    drop_table :tar_variables
  end
end
