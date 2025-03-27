class TarServicio < ApplicationRecord

	TIPOS = ['requerimiento', 'mensual', 'horas']

	MONEDAS = ['Pesos', 'UF']

	belongs_to :tipo_asesoria, optional: true
	belongs_to :ownr, polymorphic: true, optional: true

	has_many :asesorias

    validates_presence_of :descripcion, :tipo, :moneda, :monto

	def facturaciones
		TarFacturacion.where(owner_class: 'TarServicio', owner_id: self.id)
	end

end
