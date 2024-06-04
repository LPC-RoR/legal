class AddRequiereUfToTarPago < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_pagos, :requiere_uf, :boolean
    add_column :tar_pagos, :detalla_porcentaje_cuantia, :boolean
  end
end
