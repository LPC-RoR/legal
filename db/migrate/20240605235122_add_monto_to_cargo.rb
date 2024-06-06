class AddMontoToCargo < ActiveRecord::Migration[5.2]
  def change
    add_column :cargos, :monto, :decimal
  end
end
