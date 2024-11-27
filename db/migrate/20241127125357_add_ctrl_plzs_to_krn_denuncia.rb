class AddCtrlPlzsToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :fecha_prcsd, :datetime
    add_column :krn_denuncias, :plz_trmtcn, :datetime
    add_column :krn_denuncias, :plz_invstgcn, :datetime
    add_column :krn_denuncias, :plz_infrm, :datetime
    add_column :krn_denuncias, :plz_prnncmnt, :datetime
    add_column :krn_denuncias, :plz_mdds_sncns, :datetime
  end
end
