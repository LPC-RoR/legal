class AddComercialFieldsToEmpresa < ActiveRecord::Migration[8.0]
  def change
    add_column :empresas, :industry, :string
    add_index :empresas, :industry
    add_column :empresas, :company_size, :string
    add_index :empresas, :company_size
    add_column :empresas, :plan_type, :string
    add_index :empresas, :plan_type
  end
end
