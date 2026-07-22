class TarServicio < ApplicationRecord
  	include AASM

	belongs_to :ownr, polymorphic: true, optional: true

	has_many :asesorias

    validates_presence_of :descripcion, :tipo, :moneda, :monto

    # ---------------------------------------------------------------- ESTADOS con AASM

	# Proceso Operativo
	aasm(:operativo, column: 'estado') do
	    state :vigente, initial: true
	    state :vencida

	    event :up_to_vencida do
	      transitions from: :vigente, to: :vencida
	    end
	    
	    event :dwn_to_vigente do
	      transitions from: :vencida, to: :vigente
	    end
	end

	def evento_permitido?(proceso, evento)
	  # Método 100% funcional (verificado en consola)
	  aasm(proceso.to_sym).may_fire_event?(evento.to_sym)
	rescue StandardError => e
	  Rails.logger.error "🔴 Error verificando evento: #{e.message}"
	  false
	end

	def ejecutar_evento(proceso, evento)
	  # Verificación segura
	  unless evento_permitido?(proceso, evento)
	    raise ArgumentError, "Evento '#{evento}' no permitido desde estado '#{send("estado_#{proceso}")}'"
	  end

	  # Ejecutar con AASM API nativa
	  aasm(proceso.to_sym).fire!(evento.to_sym)
	end

	# ---------------------------------------------------------------------

end
