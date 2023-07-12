module Tarifas
	extend ActiveSupport::Concern

	def calcula(formula, libreria, causa, pago)

		puts "***********************calcula"
		puts formula

		while formula.match(/\([^()]*\)/) do
			segmento = formula.match(/\([^()]*\)/)[0]
			formula = formula.gsub(segmento, calcula(segmento.gsub(/\(/, '').gsub(/\)/, '').strip, libreria, causa, pago).to_s)
		end

		# aqui tengo fórmulas sin parentesis
		# hay que reconocer operaciones por pioridad = complejidad
		if formula.match(/[^\?:]+\?[^\?:]+:[^\?:]+/)
			# OPERADOR TERNRIO
			exp = formula.match(/(?<condicion>[^\?:]+)\?(?<verdadero>[^\?:]+):(?<falso>[^\?:]+)/)
			eval_condicion(exp[:condicion], libreria, causa, pago) ? eval_elemento(exp[:verdadero], libreria, causa, pago) : eval_elemento(exp[:falso], libreria, causa, pago)
		elsif formula.match(/max\[[^\[\]]+,[^\[\]]+/)
			# MAXIMO
			exp = formula.match(/max\[([^\[\]]+),([^\[\]]+)/)
			e_1 = eval_elemento(exp[1], libreria, causa, pago)
			e_2 = eval_elemento(exp[2], libreria, causa, pago)
			e_1 <= e_2 ? e_2 : e_1
		elsif formula.match(/rango\[[^\[\]]+,[^\[\]]+/)
			# RANGO
			exp = formula.match(/rango\[([^\[\]]+),([^\[\]]+),([^\[\]]+)/)
			valor = eval_elemento(exp[1], libreria, causa, pago)
			inferior = eval_elemento(exp[2], libreria, causa, pago)
			superior = eval_elemento(exp[3], libreria, causa, pago)
			
			valor > superior ? superior : (valor < inferior ? inferior : valor)
		elsif formula.match(/[^\+]+\+[^\+]+/)
			# SUMA
			exp = formula.match(/([^\+]+)\+([^\+]+)/)
			eval_elemento(exp[1], libreria, causa, pago) + eval_elemento(exp[2], libreria, causa, pago)
		elsif formula.match(/[^\+]+\-[^\+]+/)
			# RESTA
			exp = formula.match(/([^\+]+)\-([^\+]+)/)
			eval_elemento(exp[1], libreria, causa, pago) - eval_elemento(exp[2], libreria, causa, pago)
		elsif formula.match(/[^\+]+\*[^\+]+/)
			# PRODUCTO
			exp = formula.match(/([^\+]+)\*([^\+]+)/)
			eval_elemento(exp[1], libreria, causa, pago) * eval_elemento(exp[2], libreria, causa, pago)
		elsif formula.match(/[^\+]+\/[^\+]+/)
			# DIVISION
			exp = formula.match(/([^\+]+)\/([^\+]+)/)
			eval_elemento(exp[1], libreria, causa, pago) / eval_elemento(exp[2], libreria, causa, pago)
		end
	end

	def eval_condicion(condicion, libreria, causa, pago)

		# Manejo de paréntesis
		# del resultado de esto puede salir un true, false

		while condicion.match(/\([^()]*\)/) do
			segmento = condicion.match(/\([^()]*\)/)[0]
			condicion = condicion.gsub(segmento, eval_condicion(segmento.gsub(/\(/, '').gsub(/\)/, '').strip, libreria, causa, pago).to_s)
		end

		# manejo de & u |
		if condicion.match(/[^&]+\&[^&]+/)
			exps = condicion.split('&')
			cond = true
			exps.each do |e_cond|
				cond = (cond and eval_condicion(e_cond, libreria, causa, pago))
			end
			cond
		elsif condicion.match(/[^|]+\|[^|]+/)
			exps = condicion.split('|')
			cond = false
			exps.each do |e_cond|
				cond = (cond or eval_condicion(e_cond, libreria, causa, pago))
			end
			cond
		elsif condicion.match(/[^<=]+<=[^<=]+/)
			# <=
			exp = condicion.match(/(?<menor>[^<=]+)<=(?<mayor>[^<=]+)/)
			eval_elemento(exp[:menor], libreria, causa, pago) <= eval_elemento(exp[:mayor], libreria, causa, pago)
		elsif condicion.match(/[^>=]+>=[^>=]+/)
			# >=
			exp = condicion.match(/(?<mayor>[^>=]+)>=(?<menor>[^>=]+)/)
			eval_elemento(exp[:mayor], libreria, causa, pago) >= eval_elemento(exp[:menor], libreria, causa, pago)
		elsif condicion.match(/[^<]+<[^<]+/)
			# <
			exp = condicion.match(/(?<menor>[^<]+)\<(?<mayor>[^<]+)/)
			eval_elemento(exp[:menor], libreria, causa, pago) < eval_elemento(exp[:mayor], libreria, causa, pago)
		elsif condicion.match(/[^>]+>[^>]+/)
			# >
			exp = condicion.match(/(?<mayor>[^>]+)>(?<menor>[^>]+)/)
			eval_elemento(exp[:mayor], libreria, causa, pago) > eval_elemento(exp[:menor], libreria, causa, pago)
		elsif condicion.match(/[^=]+=[^=]+/)
			# =
			exp = condicion.match(/(?<mayor>[^=]+)=(?<menor>[^=]+)/)
			eval_elemento(exp[:mayor], libreria, causa, pago) == eval_elemento(exp[:menor], libreria, causa, pago)
		else 
			calcula(condicion, libreria, causa, pago)
		end
	end

	def eval_elemento(elemento, libreria, causa, pago)

		puts "********************************************** eval_elemento"
		puts elemento

		if elemento.strip[0] == '#' #Valor de la causa
			case elemento.strip
			when '#uf'
				causa.uf_pago.blank? ? 0 : (causa.uf_pago.valor.blank? ? 0 : causa.uf_pago.valor)
			when '#uf_dia'
				uf = TarUfSistema.find_by(fecha: Time.zone.today)
				uf.blank? ? 0 : uf.valor
			when '#cuantia_pesos'
				causa.cuantia_pesos(pago)
			when '#cuantia_uf'
				causa.cuantia_uf(pago)
			when '#monto_pagado'
				causa.monto_pagado.blank? ? 0 : causa.monto_pagado
			when '#monto_pagado_uf'
				causa.monto_pagado.blank? ? 0 : causa.monto_pagado / (causa.uf_pago(pago.tar_pago).blank? ? 0 : causa.uf_pago(pago.tar_pago).valor)
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
			formula.blank? ? 0 : calcula(formula.tar_formula, libreria, causa, pago)
		else # fórmula
			calcula(elemento, libreria, causa, pago)
		end
	end

end