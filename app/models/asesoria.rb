class Asesoria < ApplicationRecord
	belongs_to :cliente
	belongs_to :tipo_asesoria
	belongs_to :tar_servicio, optional: true

	has_one :tar_calculo, as: :ownr
	has_one :tar_facturacion, as: :ownr
	has_one :tar_uf_facturacion, as: :ownr

	has_many :notas, as: :ownr

    validates_presence_of :descripcion

    scope :std, ->(std) { where(estado: std).order(urgente: :desc, pendiente: :desc, created_at: :desc)}
    scope :typ, ->(typ_id) { where(estado: 'activo', tipo_asesoria_id: typ_id).order(urgente: :desc, pendiente: :desc, created_at: :desc) }

    def self.crstn(typ)
    	typ.singularize == 'Redaccion' ? 'Redacción' : typ.singularize
    end

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	def uf_facturacion
		TarUfFacturacion.where(owner_class: self.class.name).find_by(owner_id: self.id)
	end

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	def exclude_files
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Archivo').order(:nombre).map {|cd| cd.nombre}
	end

	def documentos
		AppDocumento.where(owner_class: self.class.name, owner_id: self.id)
	end

	def exclude_docs
		self.tipo_causa.blank? ? [] : self.tipo_causa.control_documentos.where(tipo: 'Documento').order(:nombre).map {|cd| cd.nombre}
	end

	def enlaces
		AppEnlace.where(owner_class: self.class.name, owner_id: self.id)
	end

	def actividades
		AgeActividad.where(owner_class: self.class.name, owner_id: self.id).order(fecha: :desc)
	end

	def sin_cargo?
		self.tar_servicio_id.blank? and self.monto.blank?
	end

	# Hasta aqui revisado!
end
