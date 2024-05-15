class Asesoria < ApplicationRecord
	belongs_to :cliente
	belongs_to :tipo_asesoria
	belongs_to :tar_servicio, optional: true

    validates_presence_of :descripcion

	def archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end

	def facturacion
		TarFacturacion.where(owner_class: self.class.name).find_by(owner_id: self.id)
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

	# Hasta aqui revisado!
end
