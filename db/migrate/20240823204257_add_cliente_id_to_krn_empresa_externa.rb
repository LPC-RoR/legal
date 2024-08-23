class AddClienteIdToKrnEmpresaExterna < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_empresa_externas, :cliente_id, :integer
    add_index :krn_empresa_externas, :cliente_id
  end
end
