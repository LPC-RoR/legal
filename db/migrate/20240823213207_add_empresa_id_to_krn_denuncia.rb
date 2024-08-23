class AddEmpresaIdToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :empresa_id, :integer
    add_index :krn_denuncias, :empresa_id
  end
end
