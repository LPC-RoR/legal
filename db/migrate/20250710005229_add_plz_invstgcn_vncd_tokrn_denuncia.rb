class AddPlzInvstgcnVncdTokrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :plz_invstgcn_vncd, :boolean
  end
end
