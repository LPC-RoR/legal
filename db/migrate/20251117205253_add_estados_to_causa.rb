class AddEstadosToCausa < ActiveRecord::Migration[8.0]
  def change
    add_column :causas, :estado_operativo, :string, default: 'en_tramitacion'
    add_column :causas, :estado_financiero, :string, default: 'sin_cobros'
    add_index :causas, :estado_operativo
    add_index :causas, :estado_financiero
  end
end
