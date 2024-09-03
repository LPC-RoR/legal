class KrnDenunciante < ApplicationRecord
	belongs_to :krn_denuncia
	belongs_to :krn_empresa_externa, optional: true
	belongs_to :krn_empleado, optional: true

	def app_archivos
		AppArchivo.where(owner_class: self.class.name, owner_id: self.id)
	end
end
