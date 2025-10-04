class AddCntctsFlagsToEmpresa < ActiveRecord::Migration[8.0]
  def change
    add_column :empresas, :verificacion_datos, :boolean
    add_column :empresas, :coordinacion_apt, :boolean
    add_column :clientes, :verificacion_datos, :boolean
    add_column :clientes, :coordinacion_apt, :boolean
  end
end
