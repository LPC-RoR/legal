class AddPorcentajeCuantiaToTarPago < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_pagos, :porcentaje_cuantia, :string
    add_column :tar_pagos, :boolean, :string
  end
end
