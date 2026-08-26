class AddVrfccnDtsTstgsToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :vrfccn_dts_tstgs, :boolean
    add_column :krn_denuncias, :evlcn_dnnc, :string
    add_column :krn_denuncias, :fecha_dnnc_crrgd, :date
  end
end
