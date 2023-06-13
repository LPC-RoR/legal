module CptnTarifasHelper

	def eval_elemento(elemento, libreria, causa)
		if elemento.strip[0] == '#' #Valor de la causa
			case elemento.strip
			when '#uf'
				causa.uf_calculo
			when '#uf_dia'
				uf = TarUfSistema.find_by(fecha: Time.zone.today)
				uf.blank? ? 0 : uf.valor
			when '#cuantia_pesos'
				causa.cuantia_pesos
			when '#cuantia_uf'
				causa.cuantia_uf
			when '#monto_pagado'
				causa.monto_pagado.blank? ? 0 : causa.monto_pagado
			when '#monto_pagado_uf'
				causa.monto_pagado.blank? ? 0 : causa.monto_pagado / causa.uf_calculo
			when '#facturado_pesos'
				causa.facturado_pesos
			when '#facturado_uf'
				causa.facturado_uf	
			end
		elsif elemento.strip[0] == '@'
			fyc = elemento.strip.match(/^@(?<facturable>.+):(?<campo>.+)/)
			facturacion = causa.facturaciones.find_by(facturable: fyc[:facturable])
			facturacion.blank? ? 0 : (facturacion.send(fyc[:campo]).blank? ? 0 : facturacion.send(fyc[:campo]))
		elsif (elemento.split(' ').length == 1) and elemento.match(/\d+\.*\d*/)	# número ya evaluado
			elemento.to_f
		elsif elemento.strip == 'true'	# condicion ya evaluda
			true
		elsif elemento.strip == 'false'	# condición ya evaluaada
			false
		elsif elemento.strip.split(' ').length == 1 # elemento de la librería
			formula = libreria.find_by(codigo: elemento.strip)
			formula.blank? ? 0 : calcula(formula.tar_formula, libreria, causa)
		else # fórmula
			calcula(elemento, libreria, causa)
		end
	end

end
