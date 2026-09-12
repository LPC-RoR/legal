class AddEmpresaNombreToLead < ActiveRecord::Migration[8.0]
  def change
    add_column :leads, :empresa_nombre, :string
  end
end
