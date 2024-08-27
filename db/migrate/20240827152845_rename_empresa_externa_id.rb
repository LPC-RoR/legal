class RenameEmpresaExternaId < ActiveRecord::Migration[7.1]
  def change
    rename_column :krn_denunciantes, :empresa_externa_id, :krn_empresa_externa_id
  end
end
