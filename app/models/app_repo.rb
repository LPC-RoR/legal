class AppRepo < ApplicationRecord

	def directorios
		AppDirectorio.where(owner_class: 'AppRepo').where(owner_id: self.id)
	end

	def documentos
		AppDocumento.where(owner_class: 'AppRepo').where(owner_id: self.id)
	end

end
