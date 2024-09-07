class RenameKrnMotivoDenunciaId < ActiveRecord::Migration[7.1]
  def change
    rename_column :krn_derivaciones, :krn_motivo_denuncia_id, :krn_motivo_derivacion_id
  end
end
