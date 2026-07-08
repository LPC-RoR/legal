class AddTipoEmpresaToEmpresa < ActiveRecord::Migration[8.0]
  def change
    add_column :empresas, :tipo_empresa, :string
  end
end
