class AddOrdenToTarPago < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_pagos, :orden, :integer
    add_index :tar_pagos, :orden
  end
end
