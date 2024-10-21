class AddOwnrToKrnInvestigador < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_investigadores, :ownr_type, :string
    add_index :krn_investigadores, :ownr_type
    add_column :krn_investigadores, :ownr_id, :integer
    add_index :krn_investigadores, :ownr_id
  end
end
