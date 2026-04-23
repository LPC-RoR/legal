class AddVrfccnDtsIncmbntsToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :vrfccn_dts_incmbnts, :boolean
  end
end
