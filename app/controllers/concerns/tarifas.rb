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
		end
	end

	def get_token_value(token, objeto, pago)
		libreria = objeto.tar_tarifa.blank? ? [] : objeto.tar_tarifa.tar_formulas
		if token.strip[0] == '#' #Valor de la causa
			case token.strip
			when '#tarifa_variable'
				#no agrego 'honorarios' porque se entiende que es lo que aplica
				t_tarifa_variable(objeto, pago)

			when '#cuantia_pesos'
				total_cuantia(objeto, 'real')

			when '#cuantia_pesos_honorarios'
				total_cuantia(objeto, 'tarifa')

			when '#cuantia_uf'
				total_cuantia_uf(objeto, pago, 'real')

			when '#cuantia_uf_honorarios'
				total_cuantia_uf(objeto, pago, 'tarifa')

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
			# se debe buscar en los TarPago de la tarifa de la causa, puede ser que exista otra tarifa con el mismo codigo_formula
			tar_pago = objeto.tar_tarifa.tar_pagos.find_by(codigo_formula: fyc[:facturable])
			if tar_pago.blank?
				0
			else
				facturacion = objeto.facturaciones.find_by(tar_pago_id: tar_pago.id)
				facturacion.blank? ? 0 : (facturacion.send(fyc[:campo]).blank? ? 0 : facturacion.send(fyc[:campo]))
			end
		elsif token.strip[0] == '$'
			# en token.gsub('$', '').strip es necesario el strip
			variable = Variable.find_by(variable: token.gsub('$', '').strip)
			if variable.blank?
				0
			else
				valor = variable.valores.find_by(owner_id: objeto.id)
				valor.blank? ? 0 : variable.valor_campo(valor)
			end
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

	# Pago es siempre nil => asume que siempre valor cuantía será en pesos
	# set_detalle_cuantia
	def get_valores_cuantia(formula, valor_campo, causa)
		if valor_campo.blank?
			valor = formula.blank? ? 0 : calcula2(formula, causa, nil)
			check = 'formula'
		else
			valor = valor_campo
			check = formula.blank? ? 'campo' : valor_campo == calcula2(formula, causa, nil) ? 'ok' : 'fail'
		end
		{ valor: valor, check: check}
	end

	# ****************************************************************** Métodos usados para la evaluación y el despliegue de pagos
	# VALORES de tar_valor cuantia que sirven para despliegue sin necesidad de otras variables
	# tipo : { 'real', 'tarifa'}
	def vlr_cuantia(tar_valor_cuantia, tipo)
		formula = tipo == 'real' ? tar_valor_cuantia.formula : tar_valor_cuantia.formula_honorarios
		valor = tipo == 'real' ? tar_valor_cuantia.valor : tar_valor_cuantia.valor_tarifa
		valor.blank? ? ( formula.blank? ? 0 : calcula2(formula, tar_valor_cuantia.owner, nil) ) : valor
	end

	def chck_cuantia(tar_valor_cuantia, tipo)
		formula = tipo == 'real' ? tar_valor_cuantia.formula : tar_valor_cuantia.formula_honorarios
		valor = tipo == 'real' ? tar_valor_cuantia.valor : tar_valor_cuantia.valor_tarifa
		valor.blank? ? 'formula' : ( formula.blank? ? 'campo' : valor == calcula2(formula, tar_valor_cuantia.owner, nil) ? 'ok' : 'fail' )
	end

	def vlr_tarifa(tar_valor_cuantia)
		tarifa = vlr_cuantia(tar_valor_cuantia, 'tarifa')
		tarifa == 0 ? vlr_cuantia(tar_valor_cuantia, 'real') : tarifa
	end

	def chck_tarifa(tar_valor_cuantia)
		tarifa = vlr_tarifa(tar_valor_cuantia)
		tarifa == 0 ? chck_cuantia(tar_valor_cuantia, 'real') : chck_cuantia(tar_valor_cuantia, 'tarifa')
	end

	def total_cuantia(causa, tipo)
		tipo == 'real' ? causa.valores_cuantia.map {|vlr_cnt| vlr_cuantia(vlr_cnt, 'real')}.sum : causa.valores_cuantia.map {|vlr_cnt| vlr_tarifa(vlr_cnt)}.sum
	end

	def total_cuantia_uf(causa, pago, tipo)
		uf = uf_calculo(causa, pago)
		uf.blank? ? 0 : total_cuantia(causa, tipo) / uf
	end

	def get_tar_calculo(causa, pago)
		causa.calculos.where(tar_pago_id: pago.id).first
	end

	def get_tar_facturacion(causa, pago)
		causa.facturaciones.where(tar_pago_id: pago.id).first
	end

	def get_tar_uf_facturacion(causa, pago)
		causa.uf_facturaciones.where(tar_pago_id: pago.id).first
	end

	# es un Array que contiene los cálculos, pagos o nil (si no hay ninguno de los anteriores)
	def pgs_stts(causa, tarifa)
		h_status = {}
		tarifa.tar_pagos.order(:orden).each do |pago|
			tar_calculo = get_tar_calculo(causa, pago)
			tar_facturacion = get_tar_facturacion(causa, pago)
			h_status[pago.id] = tar_calculo.present? ? tar_calculo : ( tar_facturacion.present? ? tar_facturacion : nil )
		end
		h_status
	end

	# este método debe aplicar a Causa y Asesoría
	def fecha_calculo(causa, pago)
		if causa.class.name == 'Causa'
			tar_uf_facturacion = get_tar_uf_facturacion(causa, pago)
			fecha1 = tar_uf_facturacion.blank? ? nil : tar_uf_facturacion.fecha_uf

			tar_calculo = get_tar_calculo(causa, pago)
			fecha2 = tar_calculo.blank? ? nil : tar_calculo.fecha_uf

			tar_facturacion = get_tar_facturacion(causa, pago)
			fecha3 = tar_facturacion.blank? ? nil : tar_facturacion.fecha_uf

			fecha1.present? ? fecha1 : ( fecha2.present? ? fecha2 : (fecha3.present? ? fecha3 : (tar_facturacion.present? ? tar_facturacion.created_at : Time.zone.today)) )
		elsif causa.class.name == 'Asesoria'
			causa.fecha_uf.present? ? causa.fecha_uf : causa.facturacion.created_at
		end
	end

	def uf_calculo(causa, pago)
		fecha_uf = fecha_calculo(causa, pago)
		fecha_uf.blank? ? nil : uf_fecha( fecha_uf )
	end

	def origen_fecha_calculo(causa, pago)
		tar_uf_facturacion = get_tar_uf_facturacion(causa, pago)
		tar_calculo = get_tar_calculo(causa, pago)
		tar_facturacion = get_tar_facturacion(causa, pago)
		tar_uf_facturacion.present? ? 'TarUfFacturacion' : ( tar_calculo.present? ? 'TarCalculo' : ( tar_facturacion.present? ? 'TarFacturacion' : 'Today' ) )
	end

	def monto_pesos(objeto, causa, pago)
		objeto.moneda == 'Pesos' ? objeto.monto : (uf_calculo(causa, pago).blank? ? 0 : objeto.monto * uf_calculo(causa, pago))
	end

	def monto_uf(objeto, causa, pago)
		['UF', '', nil].include?(objeto.moneda) ? objeto.monto : (uf_calculo(causa, pago).blank? ? 0 : objeto.monto / uf_calculo(causa, pago))
	end

    # crea el array con el cálculo del pago
    def v_monto_calculo(causa, pago)
    	tar_facturacion = get_tar_facturacion(causa, pago)
    	tar_calculo = get_tar_calculo(causa, pago)
    	uf_calculo = uf_calculo(causa, pago)
    	if tar_calculo.blank? and tar_facturacion.blank?
    		monto = pago.valor.blank? ? calcula2(pago.formula_tarifa, causa, pago) : pago.valor
	        monto_pesos = pago.moneda == 'Pesos' ? monto : ( uf_calculo.blank? ? 0 : monto * uf_calculo )
	        monto_uf = pago.moneda == 'UF' ? monto : ( uf_calculo.blank? ? 0 : monto / uf_calculo )
    	else
    		objeto = tar_calculo.present? ? tar_calculo : tar_facturacion
    		monto_pesos = monto_pesos(objeto, causa, pago)
    		monto_uf = monto_uf(objeto, causa, pago)
    	end
    	[monto_uf, monto_pesos]
    end

	def leyenda_origen_fecha_calculo(causa, pago)
		case origen_fecha_calculo(causa, pago)
		when 'TarUfFacturacion'
			'UF definida para este pago.'
		when 'TarCalculo'
			'UF de la fecha de cálculo.'
		when 'TarFacturacion'
			'UF de la fecha de aprobación.'
		when 'Today'
			'UF del día de hoy.'
		end
	end
	# ******************************************************************

	# Genera el h_cuantias con los valores y chequeos de las cuantías
	# [{valor: valor_r, check: check_r}, {valor: valor_h. check: check_h}]
	def get_h_cuantia(tar_valor_cuantia)
		causa = tar_valor_cuantia.owner_class = 'Causa' ? tar_valor_cuantia.owner : nil

		campo_r = tar_valor_cuantia.valor
		formula_r= tar_valor_cuantia.formula
		valor_r = get_valores_cuantia(formula_r, campo_r, causa)

		campo_h = tar_valor_cuantia.valor_tarifa
		formula_h = tar_valor_cuantia.formula_honorarios
		valor_h = get_valores_cuantia(formula_h, campo_h, causa)
		valor_h[:valor] = valor_r[:valor] if valor_h[:valor] == 0
		[valor_r, valor_h]
	end

	# Genera un hash con elementos tipo @valores_cuantia[id], que permite desplegar las cuantías de diferentes objetos
	# Tambien genera un hash @totales_cuantia de al misma naturaleza
	# objeto = {Causa, Asesoría}
	# causas_controller servicios_controller
	def set_detalle_cuantia(objeto, porcentaje_cuantia)
		
		# VERIFICAR necesidad del if siguiente
		@valores_cuantia = {} if @valores_cuantia.blank?
        @valores_cuantia[objeto.id] = {}
		cuantia = {}
		objeto.valores_cuantia.each do |tar_valor_cuantia|

	      	detalle_cuantia = tar_valor_cuantia.tar_detalle_cuantia

	      	cuantia[:nombre] = tar_valor_cuantia.detalle
			cuantia[:activado] = tar_valor_cuantia.activado?
			cuantia[:nota] = tar_valor_cuantia.nota
			cuantia[:moneda] = tar_valor_cuantia.moneda
			cuantia[:p100] = porcentaje_cuantia.blank? ? nil : tar_valor_cuantia.porcentaje_variable

			v_cuantia = get_h_cuantia(tar_valor_cuantia)

			cuantia[:cuantia] = v_cuantia[0][:valor]
			cuantia[:check_cuantia] = v_cuantia[0][:check]
			cuantia[:honorarios] = v_cuantia[1][:valor]
			cuantia[:check_honorarios] = v_cuantia[0][:check]

	        @valores_cuantia[objeto.id][tar_valor_cuantia.id] = cuantia
	        cuantia = {}

		end

		# Los totales se calculan usando la estructura anterior
		@totales_cuantia = {} if @totales_cuantia.blank?
		@totales_cuantia[objeto.id] = {}

		v_total_cuantia_uf =       objeto.valores_cuantia.map {|vc| @valores_cuantia[objeto.id][vc.id][:cuantia] if (vc.activado? and vc.moneda == 'UF') }.compact
		v_total_cuantia_pesos =    objeto.valores_cuantia.map {|vc| @valores_cuantia[objeto.id][vc.id][:cuantia] if (vc.activado? and vc.moneda == 'Pesos') }.compact
		v_total_honorarios_uf =    objeto.valores_cuantia.map {|vc| @valores_cuantia[objeto.id][vc.id][:honorarios] if (vc.activado? and vc.moneda == 'UF') }.compact
		v_total_honorarios_pesos = objeto.valores_cuantia.map {|vc| @valores_cuantia[objeto.id][vc.id][:honorarios] if (vc.activado? and vc.moneda == 'Pesos') }.compact

		@totales_cuantia[objeto.id][:cuantia_uf] = v_total_cuantia_uf.empty? ? 0 : v_total_cuantia_uf.sum
		@totales_cuantia[objeto.id][:cuantia_pesos] = v_total_cuantia_pesos.empty? ? 0 : v_total_cuantia_pesos.sum
		@totales_cuantia[objeto.id][:honorarios_uf] = v_total_honorarios_uf.empty? ? 0 : v_total_honorarios_uf.sum
		@totales_cuantia[objeto.id][:honorarios_pesos] = v_total_honorarios_pesos.empty? ? 0 : v_total_honorarios_pesos.sum
	end

	def array_cuantia(objeto, valores_cuantia)
		array = []
		objeto.valores_cuantia.each do |vc|
			elem = [valores_cuantia[objeto.id][vc.id][:nombre], valores_cuantia[objeto.id][vc.id][:honorarios], valores_cuantia[objeto.id][vc.id][:cuantia]]
			array << elem
		end
		array
	end

	# Calcula el valor de Cuantía de Honorarios de un tar_valor_cuantia
	def variable_base_valor(tar_valor_cuantia)
		v_cuantia = get_h_cuantia(tar_valor_cuantia)
		v_cuantia[1][:valor] * (tar_valor_cuantia.porcentaje_variable / 100)
	end

	# Monto Variable completo
	def t_tarifa_variable(causa, pago)
		causa.valores_cuantia.map {|vc| variable_base_valor(vc) }.sum
	end

	def valor_cuantia(tar_valor_cuantia, tipo_cuantia)
		get_h_cuantia(tar_valor_cuantia)[(tipo_cuantia == 'honorarios' ? 1 : 0)][:valor]
	end

	def tar_valor_cuantia_valor(causa, tvc, etiqueta)
		v_cuantia = get_h_cuantia(tar_valor_cuantia)


      	detalle_cuantia = tvc.tar_detalle_cuantia
		h_valor_cuantia = get_valores_cuantia(detalle_cuantia.formula_cuantia, tvc.valor, causa)
		h_valor_honorarios = get_valores_cuantia(tvc.formula_honorarios, tvc.valor_tarifa, causa)

		v_cuantia = h_valor_cuantia[:valor]
		v_honorarios = h_valor_honorarios[:valor] == 0 ? h_valor_cuantia[:valor] : h_valor_honorarios[:valor]

		etiqueta == 'honorarios' ? v_honorarios : v_cuantia

	end

	def v_total_cuantia(causa, tipo_cuantia)
		valores_pesos = causa.valores_cuantia.where(desactivado: false, moneda: 'Pesos')
		valores_uf = causa.valores_cuantia.where(desactivado: false, moneda: 'UF')
		v_pesos = valores_pesos.map {|tvc| valor_cuantia(tvc, tipo_cuantia)}
		v_uf = valores_uf.map {|tvc| valor_cuantia(tvc, tipo_cuantia)}
		[v_uf.empty? ? 0 : v_uf.sum, v_pesos.empty? ? 0 : v_pesos.sum]
	end

	def t_cuantia_pesos(causa, pago, tipo_cuantia)
		v_tc = v_total_cuantia(causa, tipo_cuantia)
		uf = causa.uf_calculo_pago(pago)
		valor_uf = uf.blank? ? 0 : uf.valor
		v_tc[0] * valor_uf + v_tc[1]
	end

	def t_cuantia_uf(causa, pago, tipo_cuantia)
		v_tc = v_total_cuantia(causa, tipo_cuantia)
		uf = causa.uf_calculo_pago(pago)
		valor_uf = uf.blank? ? 0 : uf.valor
		v_tc[0] + ( valor_uf == 0 ? 0 : v_tc[1] / valor_uf )
	end


end