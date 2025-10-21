class AddFechaDemoToEmpresa < ActiveRecord::Migration[8.0]
  def change
    add_column :empresas, :fecha_demo, :date
  end
end
