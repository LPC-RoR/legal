class RenameEmpresaExternaIdKrnDenunciado < ActiveRecord::Migration[7.1]
  def change
    rename_column :krn_denunciados, :empresa_externa_id, :krn_empresa_externa_id
  end
end
