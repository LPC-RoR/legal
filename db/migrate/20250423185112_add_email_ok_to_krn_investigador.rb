class AddEmailOkToKrnInvestigador < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_investigadores, :email_ok, :boolean
  end
end
