class AddFechaHoraCorregidaToKrnDenuncia < ActiveRecord::Migration[7.1]
  def change
    add_column :krn_denuncias, :fecha_hora_corregida, :datetime
  end
end
