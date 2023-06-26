class AppControlDocumento < ApplicationRecord

	TABLA_FIELDS = [
		'app_control_documento', 
		'existencia',
		'vencimiento'
	]

	def owner
		self.ownr_class.constantize.find(self.ownr_id)
	end

	def ruta
		self.app_control_documento.split('::').join('/')
	end

end
