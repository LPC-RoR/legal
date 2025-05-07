class AddBackupEmailsToCliente < ActiveRecord::Migration[8.0]
  def change
    add_column :clientes, :backup_emails, :string
    add_column :empresas, :backup_emails, :string
  end
end
