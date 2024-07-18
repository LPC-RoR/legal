class LglDocumento < ApplicationRecord

	has_many :lgl_parrafos

	require 'carrierwave/orm/activerecord'

	mount_uploader :archivo, ArchivoUploader

	def app_archivo
		self.lgl_documento
	end

end
