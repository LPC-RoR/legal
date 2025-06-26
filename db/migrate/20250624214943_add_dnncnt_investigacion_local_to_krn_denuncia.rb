class AddDnncntInvestigacionLocalToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :dnncnt_investigacion_local, :boolean
    remove_column :krn_denuncias, :krn_investigador_id, :integer
    remove_column :krn_denuncias, :plz_trmtcn, :datetime
    remove_column :krn_denuncias, :plz_invstgcn, :datetime
    remove_column :krn_denuncias, :plz_infrm, :datetime
    remove_column :krn_denuncias, :plz_prnncmnt, :datetime
    remove_column :krn_denuncias, :plz_mdds_sncns, :datetime
  end
end
