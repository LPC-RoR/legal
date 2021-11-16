class AppArchivo < ApplicationRecord

	require 'carrierwave/orm/activerecord'

	TABLA_FIELDS = [
		['archivo',    'link_file'],
		['created_at', 'diahora']
	]

	mount_uploader :archivo, ArchivoUploader

#	belongs_to :linea, optional: true
#	belongs_to :directorio, optional: true
#	belongs_to :documento, optional: true

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def d_nombre
		(self.nombre.blank? ? (self.documento.present? ? self.documento.documento : self.archivo.url.split('/').last) : self.nombre)
	end

end
