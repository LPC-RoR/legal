class AddKrnInvestigadorIdToKrnDeclaracion < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_declaraciones, :krn_investigador_id, :integer
    add_index :krn_declaraciones, :krn_investigador_id
  end
end
