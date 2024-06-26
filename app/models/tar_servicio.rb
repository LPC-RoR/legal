class TarServicio < ApplicationRecord

	TIPOS = ['requerimiento', 'mensual', 'horas']

	MONEDAS = ['Pesos', 'UF']

	belongs_to :tipo_asesoria, optional: true

	has_many :asesorias

    validates_presence_of :descripcion, :tipo, :moneda, :monto

	def padre
		owner_id.blank? ? nil : self.owner_class.constantize.find(self.owner_id)
	end

	def cliente
		self.padre
	end

	def facturaciones
		TarFacturacion.where(owner_class: 'TarServicio', owner_id: self.id)
	end

end
