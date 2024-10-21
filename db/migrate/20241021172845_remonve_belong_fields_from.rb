class RemonveBelongFieldsFrom < ActiveRecord::Migration[7.1]
  def change
    remove_column :krn_empresa_externas, :cliente_id, :integer
    remove_column :krn_empresa_externas, :empresa_id, :integer
    remove_column :krn_tipo_medidas, :cliente_id, :integer
    remove_column :krn_tipo_medidas, :empresa_id, :integer
    remove_column :krn_investigadores, :cliente_id, :integer
    remove_column :krn_investigadores, :empresa_id, :integer
  end
end
