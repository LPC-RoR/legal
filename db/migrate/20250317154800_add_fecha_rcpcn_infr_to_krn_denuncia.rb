class AddFechaRcpcnInfrToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :fecha_rcpcn_infrm, :datetime
  end
end
