class AddAuditoriaToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :auditoria, :boolean
    add_index :krn_denuncias, :auditoria
  end
end
