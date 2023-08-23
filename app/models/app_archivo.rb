class AppArchivo < ApplicationRecord

	require 'carrierwave/orm/activerecord'

	TABLA_FIELDS = [
		'f#archivo',
		'created_at'
	]

	before_save { self.app_archivo.capitalize! }

	mount_uploader :archivo, ArchivoUploader

#	belongs_to :linea, optional: true
#	belongs_to :directorio, optional: true
#	belongs_to :documento, optional: true

	def owner
		self.owner_class.constantize.find(self.owner_id)
	end

	def objeto_destino
		['AppDirectorio', 'AppRepositorio'].include?(self.owner_class) ? self.owner.objeto_destino : self.owner
	end

	def d_nombre
		(self.nombre.blank? ? (self.documento.present? ? self.documento.documento : self.archivo.url.split('/').last) : self.nombre)
	end

end
