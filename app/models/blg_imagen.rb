class BlgImagen < ApplicationRecord

	mount_uploader :imagen, BlogUploader

	def owner
		self.ownr_class.constantize.find(self.ownr_id)	
	end

end
