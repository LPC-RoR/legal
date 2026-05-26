class ChangeDefaultEstadoFinancieroOnCausas < ActiveRecord::Migration[8.0]
  def change
    change_column_default :causas, :estado_financiero, from: 'sin_cobros', to: 'ingreso'
  end
end
