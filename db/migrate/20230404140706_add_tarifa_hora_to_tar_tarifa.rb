class AddTarifaHoraToTarTarifa < ActiveRecord::Migration[5.2]
  def change
    add_column :tar_tarifas, :moneda, :string
    add_index :tar_tarifas, :moneda
    add_column :tar_tarifas, :valor, :decimal
    add_column :tar_tarifas, :valor_hora, :decimal
  end
end
