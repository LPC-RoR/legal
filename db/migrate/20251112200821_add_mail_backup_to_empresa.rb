class AddMailBackupToEmpresa < ActiveRecord::Migration[8.0]
  def change
    add_column :empresas, :mail_backup, :boolean
    add_index :empresas, :mail_backup
  end
end
