module Tarifas
	extend ActiveSupport::Concern

	def calcula2(formula, objeto, pago)
		# objeto: causa en primer caso

		# reemplaza los paréntesis de dentro hacia afuera hasta que no queden
		while formula.match(/\([^()]*\)/) do
			# almacena segmento a calcular
			segmento = formula.match(/\([^()]*\)/)[0]
			# reemplaza segmento por el cálculo
			formula = formula.gsub(segmento, calcula2(segmento.gsub(/[\(\)]/,'').strip, objeto, pago).to_s)
		end

		# tube que hacer manejo de espacios para que funcionaran bien los remplazos
		# reemplaza las MULTIPLICACIONES
		while formula.match(/^[^\+\-\*\/]+\*/) do
			segmento = formula.match(/[^ \+\-\*\/]+ *\* *[^ \+\-\*\/]+/)[0]
			mtch = segmento.match(/^(?<m1>[^\+\-\*\/]+) *\* *(?<m2>[^\+\-\*\/]+)$/)
			valor = calcula2(mtch[:m1], objeto, pago) * calcula2(mtch[:m2], objeto, pago)
			formula = formula.gsub(segmento, valor.to_s)
		end
		# reemplaza las DIVISIONES
		while formula.match(/^[^\+\-\*\/]+\//) do
			segmento = formula.match(/[^ \+\-\*\/]+ *\/ *[^ \+\-\*\/]+/)[0]
			mtch = segmento.match(/^(?<n>[^\+\-\*\/]+) *\/ *(?<d>[^\+\-\*\/]+)$/)
			valor = calcula2(mtch[:n], objeto, pago) / calcula2(mtch[:d], objeto, pago)
			formula = formula.gsub(segmento, valor.to_s)
		end
		# reemplaza las SUMAS
		while formula.match(/^[^\+\-\*\/]+\+/) do
			segmento = formula.match(/[^ \+\-\*\/]+ *\+ *[^ \+\-\*\/]+/)[0]
			mtch = segmento.match(/^(?<s1>[^\+\-\*\/]+) *\+ *(?<s2>[^\+\-\*\/]+)$/)
			valor = calcula2(mtch[:s1], objeto, pago) + calcula2(mtch[:s2], objeto, pago)
			formula = formula.gsub(segmento, valor.to_s)
		end
		# reemplaza las RESTAS
		# NO deben entrar los números negativos ( -50.00 )
		while formula.match(/^[^\+\-\*\/]+\-/) do
			segmento = formula.match(/[^ \+\-\*\/]+ *\- *[^ \+\-\*\/]+/)[0]
			mtch = segmento.match(/^(?<r1>[^\+\-\*\/]+) *\- *(?<r2>[^\+\-\*\/]+)$/)
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
			formula.split('&').map {|exp| calcula2(exp.strip, objeto, pago)}.reduce(:&)
		elsif formula.split(' ').join('').match(/^[^\|]+\|[^\|]+/)
			formula.split('|').map {|exp| calcula2(exp.strip, objeto, pago)}.reduce(:|)
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
			get_token_value(formula, objeto, pago)
#			if formula.strip[0] == '#' #Valor de la causa
#				case formula.strip
#				when '#uf'
#					objeto.uf_calculo_pago(pago).valor
#				when '#uf_dia'
#					# Hay que revisar el uso de este valor
#					uf = TarUfSistema.find_by(fecha: Time.zone.today)
#					uf.blank? ? 0 : uf.valor
#				when '#cuantia_pesos'
#					objeto.cuantia_pesos(pago)
#				when '#cuantia_uf'
#					objeto.cuantia_uf(pago)
#				when '#monto_pagado'
#					objeto.monto_pagado.blank? ? 0 : objeto.monto_pagado
#				when '#monto_pagado_uf'
#					objeto.monto_pagado_uf(pago)
#				when '#facturado_pesos'
#					objeto.facturado_pesos
#				when '#facturado_uf'
#					objeto.facturado_uf	
#				end
#			elsif formula.strip[0] == '@'
#				fyc = formula.strip.match(/^@(?<facturable>.+):(?<campo>.+)/)
#				facturacion = objeto.facturaciones.find_by(facturable: fyc[:facturable])
#				facturacion.blank? ? 0 : (facturacion.send(fyc[:campo]).blank? ? 0 : facturacion.send(fyc[:campo]))
#			elsif formula.strip[0] == '$'
#				variable = Variable.find_by(variable: formula.gsub('$', ''))
#				valor = variable.valores.find_by(owner_id: objeto.id)
#				variable.valor_campo(valor)
#			elsif (formula.split(' ').length == 1) and formula.match(/\d+\.*\d*/)	# número cte
#				formula.strip.to_f
#			elsif formula.strip == 'true'	# condicion ya evaluda
#				true
#			elsif formula.strip == 'false'	# condición ya evaluaada
#				false
#			else # elemento de la librería
#				tar_formula = libreria.find_by(codigo: formula.strip)
#				tar_formula.blank? ? 0 : calcula2(tar_formula.tar_formula, objeto, pago)
#			end
		end
	end

	def get_token_value(token, objeto, pago)
		libreria = objeto.tar_tarifa.tar_formulas
		if token.strip[0] == '#' #Valor de la causa
			case token.strip
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
		elsif token.strip[0] == '@'
			fyc = token.strip.match(/^@(?<facturable>.+):(?<campo>.+)/)
			facturacion = objeto.facturaciones.find_by(facturable: fyc[:facturable])
			facturacion.blank? ? 0 : (facturacion.send(fyc[:campo]).blank? ? 0 : facturacion.send(fyc[:campo]))
		elsif token.strip[0] == '$'
			variable = Variable.find_by(variable: token.gsub('$', ''))
			valor = variable.valores.find_by(owner_id: objeto.id)
			variable.valor_campo(valor)
		elsif (token.split(' ').length == 1) and token.match(/\d+\.*\d*/)	# número cte
			token.strip.to_f
		elsif token.strip == 'true'	# condicion ya evaluda
			true
		elsif token.strip == 'false'	# condición ya evaluaada
			false
		else # elemento de la librería
			tar_formula = libreria.find_by(codigo: token.strip)
			tar_formula.blank? ? 0 : calcula2(tar_formula.tar_formula, objeto, pago)
		end
	end

end