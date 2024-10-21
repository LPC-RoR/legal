class AddOwnrToKrnTipoMedida < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_tipo_medidas, :ownr_type, :string
    add_index :krn_tipo_medidas, :ownr_type
    add_column :krn_tipo_medidas, :ownr_id, :integer
    add_index :krn_tipo_medidas, :ownr_id
  end
end
