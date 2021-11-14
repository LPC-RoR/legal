class AppImagen < ApplicationRecord

	require 'carrierwave/orm/activerecord'

	mount_uploader :imagen, IlustracionUploader

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end
end
