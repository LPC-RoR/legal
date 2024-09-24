class RemoveOldsOwnerFromCliente < ActiveRecord::Migration[7.1]
  def change
    remove_column :krn_denuncias, :cliente_id, :integer
    remove_column :krn_denuncias, :empresa_id, :integer
  end
end
