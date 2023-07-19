class BlgArticulo < ApplicationRecord
	belongs_to :app_perfil
	belongs_to :blg_tema

	mount_uploader :imagen, BlogUploader

	def imagenes
		BlgImagen.where(ownr_class: self.class.name, ownr_id: self.id)
	end
	
end
