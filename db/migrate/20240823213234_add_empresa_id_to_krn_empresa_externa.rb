class AddEmpresaIdToKrnEmpresaExterna < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_empresa_externas, :empresa_id, :integer
    add_index :krn_empresa_externas, :empresa_id
  end
end
