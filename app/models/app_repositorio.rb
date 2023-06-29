class AppRepositorio < ApplicationRecord

	def directorios
		AppDirectorio.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def documentos
		AppDocumento.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def archivos
		AppArchivo.where(owner_class: self.class.name).where(owner_id: self.id)
	end

	def owner
		self.owner_id.blank? ? nil : self.owner_class.constantize.find(self.owner_id)
	end

	def existe_documento?(documento)
		owner = self
		documento_array = documento.split('::')
		documento_array.each_with_index do |val, index|
			if index < documento_array.length-1
				unless owner.blank?
					if owner.directorios.find_by(app_directorio: val).present?
						owner = owner.directorios.find_by(app_directorio: val)
					else
						owner = nil
					end
				end
			end
		end
		owner.blank? ? false : owner.documentos.find_by(app_documento: documento_array.last).present?
	end

	def existe_directorio?(directorio)
		not self.directorios.find_by(app_directorio: directorio).blank?
	end

	def objeto_destino
		self.owner
	end

end
