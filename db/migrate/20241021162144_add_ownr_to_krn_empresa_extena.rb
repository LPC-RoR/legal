class AddOwnrToKrnEmpresaExtena < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_empresa_externas, :ownr_type, :string
    add_index :krn_empresa_externas, :ownr_type
    add_column :krn_empresa_externas, :ownr_id, :integer
    add_index :krn_empresa_externas, :ownr_id
  end
end
