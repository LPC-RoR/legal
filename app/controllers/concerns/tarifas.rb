module Tarifas

	def pago_pendiente(causa)
		# falta condiciń de pago pendiente
		causa.tar_tarifa.tar_pagos.first
	end

end