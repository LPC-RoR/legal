class AddEmailAdtdToKrnDenunciante < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denunciantes, :email_adtd, :boolean
    add_column :krn_denunciados, :email_adtd, :boolean
    add_column :krn_testigos, :email_adtd, :boolean
    add_column :krn_investigadores, :email_adtd, :boolean
  end
end
