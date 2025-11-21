class ChangeEstadoOperativoDefaultInCausas < ActiveRecord::Migration[8.0]
  def change
    # Cambia el valor por defecto
    change_column_default :causas, :estado_operativo, from: 'en_tramitacion', to: 'tramitacion'
    
    # Actualiza registros existentes
    reversible do |dir|
      dir.up do
        Causa.where(estado_operativo: 'en_tramitacion').update_all(estado_operativo: 'tramitacion')
      end
      dir.down do
        Causa.where(estado_operativo: 'tramitacion').update_all(estado_operativo: 'en_tramitacion')
      end
    end
  end
end