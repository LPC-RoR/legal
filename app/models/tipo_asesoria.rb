class TipoAsesoria < ApplicationRecord
	has_many :asesorias
	has_many :tar_servicios

	def detalle
		self.descripcion.blank? ? self.tipo_asesoria : self.descripcion
	end

end
