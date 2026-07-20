class Asesoria < ApplicationRecord
  	include AASM

	belongs_to :cliente
	belongs_to :tipo_asesoria
	belongs_to :tar_servicio, optional: true

	has_one :tar_calculo, as: :ownr
	has_one :tar_uf_facturacion, as: :ownr

	has_many :tar_facturaciones, as: :ownr

	has_many :doc_detalles, as: :ownr

	has_many :notas, as: :ownr

    validates_presence_of :descripcion

    scope :assr_ordr, -> { order(urgente: :desc, pendiente: :desc, created_at: :desc) }

    scope :std, ->(std) { where(estado: std).order(urgente: :desc, pendiente: :desc, created_at: :desc)}
    scope :typ_id, ->(typ_id) { where(estado: 'tramitación', tipo_asesoria_id: typ_id).assr_ordr }
    scope :typ, ->(typ) { where(tipo_asesoria_id: TipoAsesoria.find_by(tipo_asesoria: typ).id, estado: 'tramitación').assr_ordr }

    delegate :descripcion, :moneda, :monto, to: :tar_servicio, prefix: true


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

    def self.crstn(typ)
    	typ.singularize == 'Redaccion' ? 'Redacción' : typ.singularize
    end

    def fecha_uf_facturacion
    	self.fecha_uf? ? self.fecha_uf : Time.zone.today.to_date
    end

    def get_uf_facturacion
    	TarUfSistema.find_by(fecha: self.fecha_uf_facturacion)
    end

    def facturable?
    	# SOLO se facturan tarifas
    	if self.tar_servicio.present?
	    	self.get_uf_facturacion.present? or self.tar_servicio_moneda == 'Pesos'
    	else
    		false
    	end
    end

    def monto_factura
    	self.tar_facturacion.present? ? self.tar_facturacion.monto : (self.tar_servicio_moneda == 'Pesos' ? self.tar_servicio_monto : (self.tar_servicio_monto * self.get_uf_facturacion.valor))
    end

	def actividades
		AgeActividad.where(owner_class: self.class.name, owner_id: self.id).order(fecha: :desc)
	end

	def sin_cargo?
		self.tar_servicio_id.blank? and self.monto.blank?
	end

	# Hasta aqui revisado!
end
