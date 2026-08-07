class AddControlPlazosToKrnDenuncia < ActiveRecord::Migration[8.0]
  def change
    # fecha_hora sigue siendo :datetime (obligación legal)
    add_column :krn_denuncias, :fecha_informe_inicio_investigacion, :date
    add_column :krn_denuncias, :fecha_termino_investigacion, :date
    add_column :krn_denuncias, :fecha_deposito_informe, :date
    add_column :krn_denuncias, :fecha_recepcion_pronunciamiento, :date
    add_column :krn_denuncias, :fecha_aplicacion_medidas, :date
  end
end