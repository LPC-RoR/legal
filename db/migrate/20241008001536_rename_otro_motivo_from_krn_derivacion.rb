class RenameOtroMotivoFromKrnDerivacion < ActiveRecord::Migration[7.1]
  def change
    rename_column :krn_derivaciones, :otro_motivo, :motivo

    remove_index :krn_derivaciones, :krn_motivo_derivacion_id
    remove_column :krn_derivaciones, :krn_motivo_derivacion_id, :integer
  end
end
