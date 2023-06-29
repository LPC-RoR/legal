class AppArchivo < ApplicationRecord

	require 'carrierwave/orm/activerecord'

	TABLA_FIELDS = [
		'f#app_archivo',
		'created_at'
	]

	mount_uploader :app_archivo, ArchivoUploader

#	belongs_to :linea, optional: true
#	belongs_to :directorio, optional: true
#	belongs_to :documento, optional: true

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def d_nombre
		(self.nombre.blank? ? (self.documento.present? ? self.documento.documento : self.app_archivo.url.split('/').last) : self.nombre)
	end

end
