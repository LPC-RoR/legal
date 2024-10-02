class RemoveMotivoDenunciaIdToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    remove_index :krn_denuncias, :motivo_denuncia_id
    remove_column :krn_denuncias, :motivo_denuncia_id, :integer
  end
end
