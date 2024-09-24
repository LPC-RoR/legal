class AddOwnrFldsToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :ownr_type, :string
    add_index :krn_denuncias, :ownr_type
    add_column :krn_denuncias, :ownr_id, :integer
    add_index :krn_denuncias, :ownr_id
  end
end
