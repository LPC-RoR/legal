module Tarifas
	extend ActiveSupport::Concern

	def calcula2(formula, objeto, pago)
		puts "***********************calcula2"
		puts formula
		# objeto: causa en primer caso
		libreria = objeto.tar_tarifa.tar_formulas

		# reemplaza los paréntesis de dentro hacia afuera hasta que no queden
		while formula.match(/\([^()]*\)/) do
			# almacena segmento a calcular
			segmento = formula.match(/\([^()]*\)/)[0]
			# reemplaza segmento por el cálculo
			formula = formula.gsub(segmento, calcula2(segmento.gsub(/[\(\)]/,'').strip, objeto, pago).to_s)
		end
		# reemplaza las MULTIPLICACIONES
		while formula.match(/\*/) do
			segmento = formula.match(/[^\+\-\*\/]+\*[^\+\-\*\/]+/)[0]
			mtch = segmento.match(/^(?<m1>[^\+\-\*\/]+)\*(?<m2>[^\+\-\*\/]+)$/)
			valor = calcula2(mtch[:m1], objeto, pago) * calcula2(mtch[:m2], objeto, pago)
			formula = formula.gsub(segmento, valor.to_s)
		end
		# reemplaza las DIVISIONES
		while formula.match(/\//) do
			segmento = formula.match(/[^\+\-\*\/]+\/[^\+\-\*\/]+/)[0]
			mtch = segmento.match(/^(?<n>[^\+\-\*\/]+)\/(?<d>[^\+\-\*\/]+)$/)
			valor = calcula2(mtch[:n], objeto, pago) / calcula2(mtch[:d], objeto, pago)
			formula = formula.gsub(segmento, valor.to_s)
		end
		# reemplaza las SUMAS
		while formula.match(/\+/) do
			segmento = formula.match(/[^\+\-\*\/]+\+[^\+\-\*\/]+/)[0]
			mtch = segmento.match(/^(?<s1>[^\+\-\*\/]+)\+(?<s2>[^\+\-\*\/]+)$/)
			valor = calcula2(mtch[:s1], objeto, pago) + calcula2(mtch[:s2], objeto, pago)
			formula = formula.gsub(segmento, valor.to_s)
		end
		# reemplaza las RESTAS
		# NO deben entrar los números negativos ( -50.00 )
		while formula.match(/^[^\+\-\*\/]+\-/) do
			segmento = formula.match(/[^\+\-\*\/]+\-[^\+\-\*\/]+/)[0]
			mtch = segmento.match(/^(?<r1>[^\+\-\*\/]+)\-(?<r2>[^\+\-\*\/]+)$/)
			valor = calcula2(mtch[:r1], objeto, pago) - calcula2(mtch[:r2], objeto, pago)
			formula = formula.gsub(segmento, valor.to_s)
		end

		# aqui tengo fórmulas sin parentesis
		# hay que reconocer operaciones por pioridad = complejidad
		# OPERADOR TERNARIO
		if formula.split(' ').join('').match(/^[^\?\:]+\?[^\?\:]+:[^\?\:]+$/)
			exp = formula.split(' ').join('').match(/^(?<condicion>[^\?\:]+)\?(?<verdadero>[^\?\:]+):(?<falso>[^\?\:]+)$/)
			calcula2(exp[:condicion], objeto, pago) ? calcula2(exp[:verdadero], objeto, pago) : calcula2(exp[:falso], objeto, pago)
		elsif formula.split(' ').join('').match(/^max\[[^\[\]]+\,[^\[\]]+\]$/)
			# MAXIMO
			exp = formula.split(' ').join('').match(/^max\[(?<izq>[^\[\]]+)\,(?<der>[^\[\]]+)\]$/)
			i = calcula2(exp[:izq], objeto, pago)
			d = calcula2(exp[:der], objeto, pago)
			i <= d ? d : i
		elsif formula.split(' ').join('').match(/^rango\[[^\[\]]+\,[^\[\]]+\,[^\[\]]+\]$/)
			# RANGO
			exp = formula.match(/^rango\[(?<valor>[^\[\]]+)\,(?<inf>[^\[\]]+)\,(?<sup>[^\[\]]+)\]$/)
			valor = calcula2(exp[:valor], objeto, pago)
			inf = calcula2(exp[:inf], objeto, pago)
			sup = calcula2(exp[:sup], objeto, pago)
			
			valor > sup ? sup : (valor < inf ? inf : valor)
		# LOGICA
		elsif formula.split(' ').join('').match(/^[^\&]+\&[^\&]+/)
			condicion.split('&').map {|exp| calcula2(exp.strip, objeto, pago)}.reduce(:&)
		elsif formula.split(' ').join('').match(/^[^\|]+\|[^\|]+/)
			condicion.split('&').map {|exp| calcula2(exp.strip, objeto, pago)}.reduce(:|)
		elsif formula.split(' ').join('').match(/^[^\<\>\=]+\<\=[^\<\>\=]+/)
			mtch = formula.split(' ').join('').match(/^([^\<\>\=]+)\<\=([^\<\>\=]+)/)
			calcula2(mtch[1], objeto, pago) <= calcula2(mtch[2], objeto, pago)
		elsif formula.split(' ').join('').match(/^[^\<\>\=]+\>\=[^\<\>\=]+/)
			mtch = formula.split(' ').join('').match(/^([^\<\>\=]+)\>\=([^\<\>\=]+)/)
			calcula2(mtch[1], objeto, pago) >= calcula2(mtch[2], objeto, pago)
		elsif formula.split(' ').join('').match(/^[^\<\>\=]+\<[^\<\>\=]+/)
			mtch = formula.split(' ').join('').match(/^([^\<\>\=]+)\<([^\<\>\=]+)/)
			calcula2(mtch[1], objeto, pago) < calcula2(mtch[2], objeto, pago)
		elsif formula.split(' ').join('').match(/^[^\<\>\=]+\>[^\<\>\=]+/)
			mtch = formula.split(' ').join('').match(/^([^\<\>\=]+)\>([^\<\>\=]+)/)
			calcula2(mtch[1], objeto, pago) > calcula2(mtch[2], objeto, pago)
		elsif formula.split(' ').join('').match(/^[^\<\>\=]+\=[^\<\>\=]+/)
			mtch = formula.split(' ').join('').match(/^([^\<\>\=]+)\=([^\<\>\=]+)/)
			calcula2(mtch[1], objeto, pago) == calcula2(mtch[2], objeto, pago)
		# ELEMENTOS
		elsif formula.split(' ').length == 1
			if formula.strip[0] == '#' #Valor de la causa
				case formula.strip
				when '#uf'
					objeto.uf_calculo_pago(pago).valor
				when '#uf_dia'
					# Hay que revisar el uso de este valor
					uf = TarUfSistema.find_by(fecha: Time.zone.today)
					uf.blank? ? 0 : uf.valor
				when '#cuantia_pesos'
					objeto.cuantia_pesos(pago)
				when '#cuantia_uf'
					objeto.cuantia_uf(pago)
				when '#monto_pagado'
					objeto.monto_pagado.blank? ? 0 : objeto.monto_pagado
				when '#monto_pagado_uf'
					objeto.monto_pagado_uf(pago)
				when '#facturado_pesos'
					objeto.facturado_pesos
				when '#facturado_uf'
					objeto.facturado_uf	
				end
			elsif formula.strip[0] == '@'
				fyc = formula.strip.match(/^@(?<facturable>.+):(?<campo>.+)/)
				facturacion = objeto.facturaciones.find_by(facturable: fyc[:facturable])
				facturacion.blank? ? 0 : (facturacion.send(fyc[:campo]).blank? ? 0 : facturacion.send(fyc[:campo]))
			elsif (formula.split(' ').length == 1) and formula.match(/\d+\.*\d*/)	# número ya evaluado
				formula.to_f
			elsif formula.strip == 'true'	# condicion ya evaluda
				true
			elsif formula.strip == 'false'	# condición ya evaluaada
				false
			else # elemento de la librería
				tar_formula = libreria.find_by(codigo: formula.strip)
				tar_formula.blank? ? 0 : calcula2(tar_formula.tar_formula, objeto, pago)
			end
		end
	end

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