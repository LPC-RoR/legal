class AppArchivo < ApplicationRecord

	belongs_to :ownr, polymorphic:true

	has_many :causa_archivos
	has_many :causas, through: :causa_archivos

	has_many :hecho_archivos
	has_many :hechos, through: :hecho_archivos

	require 'carrierwave/orm/activerecord'

#	before_save { self.app_archivo.capitalize! }

	mount_uploader :archivo, ArchivoUploader

	# Nombres
	def self.nms
		all.map {|archv| archv.app_archivo}		
	end

	# REVISAR, probablemente DEPRECATED

	def objeto_destino
		['AppDirectorio', 'AppRepositorio'].include?(self.ownr_type) ? self.ownr.objeto_destino : self.ownr
	end

	def d_nombre
		(self.nombre.blank? ? (self.documento.present? ? self.documento.documento : self.archivo.url.split('/').last) : self.nombre)
	end

end
