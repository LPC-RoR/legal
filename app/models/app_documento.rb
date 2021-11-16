class AppDocumento < ApplicationRecord

	TABLA_FIELDS = [
		['documento',      'show'],
		['d_version', 'link_file']
	]

#	belongs_to :app_repo, optional: true
#	belongs_to :app_directorio, optional: true

#	has_many :archivos

	def archivos
		AppArchivo.where(owner_class: 'AppDocumento').where(owner_id: self.id)
	end

	def padre
		self.owner_class.constantize.find(self.owner_id)
	end

	def d_version
		self.archivos.empty? ? nil : self.archivos.order(created_at: :desc).first.archivo
	end

end
