class ChangeEmailOkToStringInKrnInvestigador < ActiveRecord::Migration[8.0]
  def change
    # Cambiar el tipo de columna (puede causar pérdida de datos si no manejas la conversión)
    change_column :krn_investigadores, :email_ok, :string
  end
end
