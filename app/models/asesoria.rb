class Asesoria < ApplicationRecord
	belongs_to :cliente
	belongs_to :tipo_asesoria
	belongs_to :tar_servicio, optional: true

	has_one :tar_facturacion, as: :ownr

	has_one :tar_calculo, as: :ownr
	has_one :tar_uf_facturacion, as: :ownr

	has_many :notas, as: :ownr

    validates_presence_of :descripcion

    scope :assr_ordr, -> { order(urgente: :desc, pendiente: :desc, created_at: :desc) }

    scope :std, ->(std) { where(estado: std).order(urgente: :desc, pendiente: :desc, created_at: :desc)}
    scope :typ_id, ->(typ_id) { where(estado: 'tramitación', tipo_asesoria_id: typ_id).assr_ordr }
    scope :typ, ->(typ) { where(tipo_asesoria_id: TipoAsesoria.find_by(tipo_asesoria: typ).id, estado: 'tramitación').assr_ordr }

    delegate :descripcion, :moneda, :monto, to: :tar_servicio, prefix: true

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
