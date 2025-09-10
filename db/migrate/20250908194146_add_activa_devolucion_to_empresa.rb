class AddActivaDevolucionToEmpresa < ActiveRecord::Migration[8.0]
  def change
    add_column :empresas, :activa_devolucion, :boolean
  end
end
