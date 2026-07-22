class Asesoria < ApplicationRecord
  	include AASM

	belongs_to :cliente
	belongs_to :tar_servicio, optional: true
	before_save :asignar_tarifa_por_defecto, if: :debe_asignar_tarifa?

	has_many :tar_facturaciones, as: :ownr

	has_many :doc_detalles, as: :ownr

	has_many :notas, as: :ownr

    validates_presence_of :descripcion

    scope :assr_ordr, -> { order(created_at: :desc) }

	# Activos!
	scope :std_oprtv, ->(std) {where(estado_operativo: std)}
	scope :std_fnncr, ->(std) {where(estado_financiero: std)}
	scope :rcnts, 		-> { where("created_at >= ?", 30.days.ago) }

    delegate :descripcion, :moneda, :monto, to: :tar_servicio, prefix: true

    def dsply_moneda
    	# tar_servicio.nil? => servicio_base (incluido en la tarifa mensual)
    	tar_servicio.nil? ? nil : (tar_servicio.tarifa_variable ? moneda : tar_servicio_moneda)
    end

    def dsply_monto
    	# tar_servicio.nil? => servicio_base (incluido en la tarifa mensual)
    	tar_servicio.nil? ? nil : (tar_servicio.tarifa_variable ? monto : tar_servicio_monto)
    end
    # ---------------------------------------------------------------- ESTADOS con AASM

	# Proceso Operativo
	aasm(:operativo, column: 'estado_operativo') do
	    state :tramitacion, initial: true
	    state :archivada

	    event :up_to_archivada do
	      transitions from: :tramitacion, to: :archivada
	    end
	    
	    event :dwn_to_tramitacion do
	      transitions from: :archivada, to: :tramitacion
	    end
	end

	# Proceso Financiero
	# app/models/causa.rb
	aasm(:financiero, column: 'estado_financiero') do
		state :ingreso, initial: true
		state :facturable
		state :con_facturaciones
		state :facturada
		state :cobrada

		# Transiciones principales (flujo normal)
		event :marcar_facturable do
			transitions from: :ingreso, to: :facturable
		end

		event :marcar_con_facturaciones do
			transitions from: :facturable, to: :con_facturaciones
		end

		event :marcar_facturada do
			transitions from: [:facturable, :con_facturaciones], to: :facturada
		end

		event :marcar_cobrada do
			transitions from: :facturada, to: :cobrada
		end

		# Transiciones de retroceso
		event :volver_a_ingreso do
			transitions from: :facturable, to: :ingreso
		end

		event :volver_a_facturable do
			transitions from: [:con_facturaciones, :facturada], to: :facturable
		end

		event :volver_a_con_facturaciones do
			transitions from: :facturada, to: :con_facturaciones
		end

		event :volver_a_facturada do
			transitions from: :cobrada, to: :facturada
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

	private

	# Solo asigna si el tipo está presente y no hay tar_servicio ya asignada
	# (o si se cambió el tipo y hay que actualizar la tarifa)
	def debe_asignar_tarifa?
    	tipo.present? && (tar_servicio_id.blank? || tipo_changed?)
	end

	def asignar_tarifa_por_defecto
	    tarifa = TarServicio
	      .where(tipo: tipo, tarifa_por_defecto: true)
	      .order(created_at: :desc)  # la más reciente
	      .first

	    self.tar_servicio = tarifa if tarifa.present?
	end

end
