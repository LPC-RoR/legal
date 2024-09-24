class AddOwnerToKrnInvestigador < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_investigadores, :cliente_id, :integer
    add_index :krn_investigadores, :cliente_id
    add_column :krn_investigadores, :empresa_id, :integer
    add_index :krn_investigadores, :empresa_id
  end
end
