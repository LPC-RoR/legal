module Tarifas
	extend ActiveSupport::Concern

	def set_formulas(objeto)
		@calc_formulas = {} if @calc_formulas.blank?

		unless objeto.tar_tarifa.blank? or objeto.tar_tarifa.tar_formulas.empty?
			objeto.tar_tarifa.tar_formulas.each do |tar_formula|
				@calc_formulas[tar_formula.codigo] = tar_formula.tar_formula
			end
		end
	end

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
		end
	end

	def get_token_value(token, objeto, pago)
		libreria = objeto.tar_tarifa.blank? ? [] : objeto.tar_tarifa.tar_formulas
		if token.strip[0] == '#' #Valor de la causa
			case token.strip
			when '#cuantia_pesos'
				t_cuantia_pesos(objeto, pago, 'cuantia')
			when '#cuantia_pesos_honorarios'
				t_cuantia_pesos(objeto, pago, 'honorarios')
			when '#cuantia_uf'
				t_cuantia_uf(objeto, pago, 'cuantia')
			when '#cuantia_uf_honorarios'
				t_cuantia_uf(objeto, pago, 'honorarios')
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
			tar_pago = TarPago.find_by(formula: fyc[:facturable])
			facturacion = objeto.facturaciones.find_by(tar_pago_id: tar_pago.id)
			facturacion.blank? ? 0 : (facturacion.send(fyc[:campo]).blank? ? 0 : facturacion.send(fyc[:campo]))
		elsif token.strip[0] == '$'
			# en token.gsub('$', '').strip es necesario el strip
			variable = Variable.find_by(variable: token.gsub('$', '').strip)
			valor = variable.valores.find_by(owner_id: objeto.id)
			valor.blank? ? 0 : variable.valor_campo(valor)
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

	def get_valores_cuantia(formula, campo, objeto)
		if campo.blank?
			valor = formula.blank? ? 0 : calcula2(formula, objeto, nil)
			check = 'formula'
		else
			valor = campo
			check = formula.blank? ? 'campo' : campo == calcula2(formula, objeto, nil) ? 'ok' : 'fail'
		end
		{ valor: valor, check: check}
	end

	def get_formula_honorarios(objeto, detalle_cuantia)
		if objeto.tar_tarifa.blank?
			nil
		else
			tarifa = objeto.tar_tarifa
			if tarifa.cuantia_tarifa
				formula = tarifa.tar_formula_cuantias.find_by(tar_detalle_cuantia_id: detalle_cuantia.id)
				formula.blank? ? nil : formula.tar_formula_cuantia
			else
				nil
			end
		end
	end

	def set_detalle_cuantia(objeto)
		@valores_cuantia = {} if @valores_cuantia.blank?
        @valores_cuantia[objeto.id] = {}
		cuantia = {}
		objeto.valores_cuantia.each do |valor_cuantia|

	      	detalle_cuantia = valor_cuantia.tar_detalle_cuantia

			if cuantia[:nombre] = detalle_cuantia.tar_detalle_cuantia == 'Otro'
				cuantia[:nombre] = valor_cuantia.otro_detalle
			else
				cuantia[:nombre] = detalle_cuantia.tar_detalle_cuantia
			end

			cuantia[:moneda] = valor_cuantia.moneda
			# versión de @valores cuantía sin fórmular. Solo mira lo ingresado como datos de la demanda
			h_cuantia = get_valores_cuantia(detalle_cuantia.formula_cuantia, valor_cuantia.valor, objeto)
			h_honorarios =  get_valores_cuantia(get_formula_honorarios(objeto, detalle_cuantia), valor_cuantia.valor_tarifa, objeto)

			cuantia[:cuantia] = h_cuantia[:valor]
			cuantia[:check_cuantia] = h_cuantia[:check]
			cuantia[:honorarios] = h_honorarios[:valor] == 0 ? h_cuantia[:valor] : h_honorarios[:valor]
			cuantia[:check_honorarios] = h_honorarios[:valor] == 0 ? h_cuantia[:check] : h_honorarios[:check]

	        @valores_cuantia[objeto.id][valor_cuantia.id] = cuantia
	        cuantia = {}

		end

		@totales_cuantia = {} if @totales_cuantia.blank?
		@totales_cuantia[objeto.id] = {}

		v_total_cuantia_uf =       objeto.valores_cuantia.map {|vc| @valores_cuantia[objeto.id][vc.id][:cuantia] if vc.moneda == 'UF' }.compact
		v_total_cuantia_pesos =    objeto.valores_cuantia.map {|vc| @valores_cuantia[objeto.id][vc.id][:cuantia] if vc.moneda == 'Pesos' }.compact
		v_total_honorarios_uf =    objeto.valores_cuantia.map {|vc| @valores_cuantia[objeto.id][vc.id][:honorarios] if vc.moneda == 'UF' }.compact
		v_total_honorarios_pesos = objeto.valores_cuantia.map {|vc| @valores_cuantia[objeto.id][vc.id][:honorarios] if vc.moneda == 'Pesos' }.compact

		@totales_cuantia[objeto.id][:cuantia_uf] = v_total_cuantia_uf.empty? ? 0 : v_total_cuantia_uf.sum
		@totales_cuantia[objeto.id][:cuantia_pesos] = v_total_cuantia_pesos.empty? ? 0 : v_total_cuantia_pesos.sum
		@totales_cuantia[objeto.id][:honorarios_uf] = v_total_honorarios_uf.empty? ? 0 : v_total_honorarios_uf.sum
		@totales_cuantia[objeto.id][:honorarios_pesos] = v_total_honorarios_pesos.empty? ? 0 : v_total_honorarios_pesos.sum
	end

	# Anejo de TarValorCuantia con FORMULAS

	def tar_valor_cuantia_valor(causa, tvc, etiqueta)

      	detalle_cuantia = tvc.tar_detalle_cuantia
		h_valor_cuantia = get_valores_cuantia(detalle_cuantia.formula_cuantia, tvc.valor, causa)
		h_valor_honorarios = get_valores_cuantia(get_formula_honorarios(causa, detalle_cuantia), tvc.valor_tarifa, causa)

		v_cuantia = h_valor_cuantia[:valor]
		v_honorarios = h_valor_honorarios[:valor] == 0 ? h_valor_cuantia[:valor] : h_valor_honorarios[:valor]

		etiqueta == 'honorarios' ? v_honorarios : v_cuantia

	end

	# DEPRECATED
	def t_total_cuantia(causa, pago, etiqueta)
		v_pesos = causa.valores_cuantia.map {|vc| tar_valor_cuantia_valor(causa, vc, etiqueta) if vc.moneda == 'Pesos'}.compact
		v_uf    = causa.valores_cuantia.map {|vc| tar_valor_cuantia_valor(causa, vc, etiqueta) if vc.moneda != 'Pesos'}.compact
		pesos = v_pesos.empty? ? 0 : v_pesos.sum
		uf    = v_uf.empty? ? 0 : v_uf.sum
		[uf, pesos]
	end

	def t_cuantia_pesos(causa, pago, etiqueta)
		tc = t_total_cuantia(causa, pago, etiqueta)
		uf = causa.uf_calculo_pago(pago)
		valor_uf = uf.blank? ? 0 : uf.valor
		tc[0] * valor_uf + tc[1]
	end

	# DEPRECATED
	def t_cuantia_uf(causa, pago, etiqueta)
		tc = t_total_cuantia(causa, pago, etiqueta)
		uf = causa.uf_calculo_pago(pago)
		valor_uf = uf.blank? ? 0 : uf.valor
		valor_uf == 0 ? 0 : tc[0] + tc[1] / valor_uf
	end


end