class AddDemoToEmpresa < ActiveRecord::Migration[7.1]
  def change
    add_column :empresas, :demo, :string
    add_column :empresas, :contacto, :boolean
  end
end
