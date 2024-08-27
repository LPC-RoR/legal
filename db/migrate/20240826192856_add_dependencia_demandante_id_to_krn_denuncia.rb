class AddDependenciaDemandanteIdToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :dependencia_denunciante_id, :integer
    add_index :krn_denuncias, :dependencia_denunciante_id
  end
end
