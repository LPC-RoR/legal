class AddCodeCausaToTipoCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :tipo_causas, :code_causa, :string
    add_index :tipo_causas, :code_causa
    add_column :causas, :code_causa, :string
    add_index :causas, :code_causa
    add_column :tar_tarifas, :code_causa, :string
    add_index :tar_tarifas, :code_causa
    add_column :tar_tipo_variables, :code_causa, :string
    add_index :tar_tipo_variables, :code_causa
  end
end
