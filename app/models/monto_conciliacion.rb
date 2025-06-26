class MontoConciliacion < ApplicationRecord

	TIPOS = ['Autorizado', 'Ofrecido', 'Propuesta', 'Contrapropuesta', 'Acuerdo', 'Sentencia']

	belongs_to :causa

	scope :ordr_fecha, -> { order(:created_at) }

	after_destroy :update_monto_pagado

	def update_monto_pagado
      causa = self.causa
      ultimo = causa.monto_conciliaciones.last
      if ultimo.present? and ['Acuerdo', 'Sentencia'].include?(ultimo.tipo)
	      causa.monto_pagado = ultimo.monto
	      causa.estado = 'pagada'
	    else
	      causa.monto_pagado = nil
        if causa.tar_tarifa.present?
          causa.estado = n_clcls == 0 ? 'ingreso' : (n_clcls == n_pgs ? 'terminada' : (causa.monto_pagado.blank? ? 'tramitación' : 'pagada'))
        else
          causa.estado = causa.monto_pagado.blank? ? 'tramitación' : 'pagada'
        end
	    end
      causa.save
	end
end
