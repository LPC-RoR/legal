class AddKrnInvestigadorIdToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :krn_investigador_id, :integer
    add_index :krn_denuncias, :krn_investigador_id
  end
end
