class AppArchivo < ApplicationRecord

	has_many :causa_archivos
	has_many :causas, through: :causa_archivos

	has_many :hecho_archivos
	has_many :hechos, through: :hecho_archivos

	require 'carrierwave/orm/activerecord'

#	before_save { self.app_archivo.capitalize! }

	mount_uploader :archivo, ArchivoUploader

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
