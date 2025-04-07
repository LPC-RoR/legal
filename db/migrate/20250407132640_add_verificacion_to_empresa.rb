class AddVerificacionToEmpresa < ActiveRecord::Migration[8.0]
  def change
    add_column :empresas, :email_verified, :boolean
    add_column :empresas, :verification_token, :string
  end
end
