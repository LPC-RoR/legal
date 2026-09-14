class DropFacturaNotaCredito < ActiveRecord::Migration[8.0]
  def change
    drop_table :tar_facturas
    drop_table :tar_nota_creditos
  end
end
