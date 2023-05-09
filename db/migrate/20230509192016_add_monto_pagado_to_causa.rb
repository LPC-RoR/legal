class AddMontoPagadoToCausa < ActiveRecord::Migration[5.2]
  def change
    add_column :causas, :monto_pagado, :decimal
  end
end
