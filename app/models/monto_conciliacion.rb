class MontoConciliacion < ApplicationRecord

	TIPOS = ['Autorizado', 'Ofrecido', 'Propuesta', 'Contrapropuesta', 'Acuerdo', 'Sentencia']

	belongs_to :causa

	scope :ordr_fecha, -> { order(:created_at) }

	after_destroy :update_monto_pagado

	def update_monto_pagado
      causa = self.causa
      ultimo = causa.monto_conciliaciones.last
      causa.monto_pagado = (ultimo.present? and ['Acuerdo', 'Sentencia'].include?(ultimo.tipo)) ? ultimo.monto : nil
      causa.save
	end
end
