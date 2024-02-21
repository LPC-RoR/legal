class TarCuota < ApplicationRecord
	belongs_to :tar_pago

	has_many :tar_facturaciones

	def monto_pagado(owner, monto)
		realizados = owner.facturaciones.where(tar_cuota_id: self.id)
		if self.moneda == 'UF'
			realizados.empty? ? 0 : realizados.map {|fact| fact.monto_uf}.sum
		else
			realizados.empty? ? 0 : realizados.map {|fact| fact.monto_pesos}.sum
		end
	end

	def monto_cuota(owner, monto)
		if self.ultima_cuota
			monto - self.monto_pagado
		else
			if self.monto.present?
				((monto - self.monto_pagado) >= self.monto) ? self.monto : 0
			elsif self.porcentaje.present?
				((monto - self.monto_pagado) >= ((monto * self.porcentaje) / 100)) ? ((monto * self.porcentaje) / 100) : 0
			else
				0
			end
		end
	end

	# ------------------------------------ ORDER LIST

	def owner
		self.tar_pago
	end

	def list
		self.owner.tar_cuotas.order(:orden)
	end

	def n_list
		self.list.count
	end

	def siguiente
		self.list.find_by(orden: self.orden + 1)
	end

	def anterior
		self.list.find_by(orden: self.orden - 1)
	end

	def redireccion
		"/tar_pagos/#{self.owner.id}"
	end

	# -----------------------------------------------

end
