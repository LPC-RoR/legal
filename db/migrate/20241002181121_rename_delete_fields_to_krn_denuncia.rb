class RenameDeleteFieldsToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    rename_column :krn_denuncias, :empresa_receptora_id, :krn_empresa_externa_id

    remove_index :krn_denuncias, :dependencia_denunciante_id
    remove_column :krn_denuncias, :dependencia_denunciante_id, :integer
    remove_index :krn_denuncias, :investigador_id
    remove_column :krn_denuncias, :investigador_id, :integer
  end
end
