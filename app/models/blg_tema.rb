class BlgTema < ApplicationRecord

	has_many :blg_articulos

	mount_uploader :imagen, BlogUploader

	def imagenes
		BlgImagen.where(ownr_class: self.class.name, ownr_id: self.id)
	end
	
end
