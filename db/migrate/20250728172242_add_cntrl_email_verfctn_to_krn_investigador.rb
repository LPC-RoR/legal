class AddCntrlEmailVerfctnToKrnInvestigador < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_investigadores, :n_vrfccn_lnks, :integer
    add_column :krn_investigadores, :fecha_vrfccn_lnk, :datetime
    add_column :krn_denunciantes, :n_vrfccn_lnks, :integer
    add_column :krn_denunciantes, :fecha_vrfccn_lnk, :datetime
    add_column :krn_denunciados, :n_vrfccn_lnks, :integer
    add_column :krn_denunciados, :fecha_vrfccn_lnk, :datetime
    add_column :krn_testigos, :n_vrfccn_lnks, :integer
    add_column :krn_testigos, :fecha_vrfccn_lnk, :datetime
  end
end
