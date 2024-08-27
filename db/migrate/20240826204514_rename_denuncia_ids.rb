class RenameDenunciaIds < ActiveRecord::Migration[7.1]
  def change
    rename_column :krn_denunciantes, :denuncia_id, :krn_denuncia_id
    rename_column :krn_denunciados, :denuncia_id, :krn_denuncia_id
  end
end
