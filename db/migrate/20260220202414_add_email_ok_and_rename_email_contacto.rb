class AddEmailOkAndRenameEmailContacto < ActiveRecord::Migration[8.0]
  def change
    # Agregar el nuevo campo string email_ok
    add_column :krn_empresa_externas, :email_ok, :string

    # Renombrar el campo email_contacto a email
    rename_column :krn_empresa_externas, :email_contacto, :email
  end
end
