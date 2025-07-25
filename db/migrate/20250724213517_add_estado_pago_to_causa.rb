class AddEstadoPagoToCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :causas, :estado_pago, :string
    add_index :causas, :estado_pago
  end
end
