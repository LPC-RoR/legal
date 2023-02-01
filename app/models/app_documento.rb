class AppDocumento < ApplicationRecord

	TABLA_FIELDS = [
		's#documento',
		'f#d_version'
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
