class AddSolicitudDenunciaToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    add_column :krn_denuncias, :solicitud_denuncia, :boolean
  end
end
