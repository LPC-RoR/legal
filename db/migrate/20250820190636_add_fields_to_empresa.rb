class AddFieldsToEmpresa < ActiveRecord::Migration[8.0]
  def change
    add_column :empresas, :administrador, :string
    add_column :empresas, :telefono, :string
    add_column :empresas, :informacion_comercial, :boolean
  end
end
