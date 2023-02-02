class AddClienteIdToRegReporte < ActiveRecord::Migration[5.2]
  def change
    add_column :reg_reportes, :cliente_id, :integer
    add_index :reg_reportes, :cliente_id
  end
end
