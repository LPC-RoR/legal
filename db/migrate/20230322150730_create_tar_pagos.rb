class CreateTarPagos < ActiveRecord::Migration[5.2]
  def change
    create_table :tar_pagos do |t|
      t.integer :tar_tarifa_id
      t.string :tar_pago
      t.string :estado
      t.string :moneda
      t.decimal :valor

      t.timestamps
    end
    add_index :tar_pagos, :tar_tarifa_id
    add_index :tar_pagos, :tar_pago
  end
end
