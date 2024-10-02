class RemoveReceptorDenunciaIdToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    remove_index :krn_denuncias, :receptor_denuncia_id
    remove_column :krn_denuncias, :receptor_denuncia_id, :integer
  end
end
