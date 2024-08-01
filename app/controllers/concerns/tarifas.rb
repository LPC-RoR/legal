module Tarifas
	extend ActiveSupport::Concern

	def parentesis_less(formula, objeto, pago)
		while formula.match?(/\([^()]*\)/) do
			segmento = formula.match(/\([^()]*\)/)[0]
			calculo = calcula2(segmento.gsub(/[\(\)]/,'').strip, objeto, pago).to_s
			formula = formula.gsub(segmento, calculo)
		end
		formula
	end

	def ternario_less(formula, objeto, pago)
		ter = '(([^:\*\/\+\-]+)\?([^\:]+):(.+))'
		while formula.match?(/#{ter}/) do
			formula.match(/#{ter}/)
			calculo = calcula2($2, objeto, pago) ? calcula2($3, objeto, pago).to_s : calcula2($4, objeto, pago).to_s
			formula = formula.gsub($1, calculo)
		end
		formula
	end

	def funciones_less(formula, objeto, pago)
		fns = '((rango|min|max)\[([^\]\[]+)\])'
		while formula.match?(/#{fns}/) do
			formula.match(/#{fns}/)
			v = $3.split(',')
			v1 = calcula2(v[0], objeto, pago)
			v2 = calcula2(v[1], objeto, pago)
			v3 = calcula2(v[2], objeto, pago)
			if $2 == 'rango'
				calculo = v1 > v3 ? v3.to_s : (v1 < v2 ? v2.to_s : v1.to_s)
			elsif $2 == 'min'
				calculo = v1 < v2 ? v1.to_s : v2.to_s
			elsif $2 == 'max'
				calculo = v1 > v2 ? v1.to_s : v2.to_s
			end
			formula = formula.gsub($1, calculo)
		end
		formula
	end

	def datos_less(formula, objeto, pago)
		datos = '(\$([a-z_]+))\b'
		while formula.match?(/#{datos}/) do
			formula.match(/#{datos}/)
			variable = Variable.find_by(variable: $2)
			if variable.blank?
				calculo = 0
			else
				valor = variable.valores.find_by(owner_id: objeto.id)
				calculo = valor.blank? ? 0 : variable.valor_campo(valor)
			end
			formula = formula.gsub($1, calculo.to_s)
		end
		formula
	end

	def lookup_less(formula, objeto, pago)
		lookup= "(@([a-z_]+):([a-z_]+))"
		while formula.match?(/#{lookup}/) do
			formula.match(/#{lookup}/)
			facturable = $2
			campo = $3
			tar_pago = objeto.tar_tarifa.tar_pagos.find_by(codigo_formula: facturable)
			if tar_pago.blank?
				calculo = 0
			else
				facturacion = objeto.facturaciones.find_by(tar_pago_id: tar_pago.id)
				calculo = facturacion.blank? ? 0 : (facturacion.send(campo).blank? ? 0 : facturacion.send(campo))
			end
			formula = formula.gsub($1, calculo.to_s)
		end
		formula
	end

	def operaciones_1_less(formula, objeto, pago)
		variable = '(?:[#@]|\b)[a-zA-Z]\w*\b'     # Debe partir con un caracter
		numero = '\b(?<!\.)\d+(?:\.\d+)?(?!\.)\b' # Decimales opcional y verifica lo que no debe ser
		elem = "#{variable}|#{numero}"
		reg = /((?>#{elem})\s*([\*\/]\=?)\s*(?>#{elem}))/
		while formula.match?(/#{reg}/) do
			formula.match(/#{reg}/)
			v = $1.split($2)
			case $2
			when '*'
				calculo = calcula2(v[0], objeto, pago) * calcula2(v[1], objeto, pago)
			when '/'
				calculo = calcula2(v[0], objeto, pago) / calcula2(v[1], objeto, pago)
			end
			formula = formula.gsub($1, calculo.to_s)
		end
		formula
	end

	def operaciones_2_less(formula, objeto, pago)
		variable = '(?:[#@]|\b)[a-zA-Z]\w*\b'     # Debe partir con un caracter
		numero = '\b(?<!\.)\d+(?:\.\d+)?(?!\.)\b' # Decimales opcional y verifica lo que no debe ser
		elem = "#{variable}|#{numero}"
		reg = /((?>#{elem})\s*([-\+]\=?)\s*(?>#{elem}))/
		while formula.match?(/#{reg}/) do
			formula.match(/#{reg}/)
			v = $1.split($2)
			case $2
			when '-'
				calculo = calcula2(v[0], objeto, pago) - calcula2(v[1], objeto, pago)
			when '+'
				calculo = calcula2(v[0], objeto, pago) + calcula2(v[1], objeto, pago)
			end
			formula = formula.gsub($1, calculo.to_s)
		end
		formula
	end

	def logica_math_less(formula, objeto, pago)
		variable = '(?:[#@]|\b)[a-zA-Z]\w*\b'     # Debe partir con un caracter
		numero = '\b(?<!\.)\d+(?:\.\d+)?(?!\.)\b' # Decimales opcional y verifica lo que no debe ser
		elem = "#{variable}|#{numero}"
		reg = /((?>#{elem})\s*([\>\<\=\!]\=?)\s*(?>#{elem}))/
		while formula.match?(/#{reg}/) do
			formula.match(/#{reg}/)
			v = $1.split($2)
			case $2
			when '>'
				calculo = calcula2(v[0], objeto, pago) > calcula2(v[1], objeto, pago)
			when '>='
				calculo = calcula2(v[0], objeto, pago) >= calcula2(v[1], objeto, pago)
			when '<'
				calculo = calcula2(v[0], objeto, pago) < calcula2(v[1], objeto, pago)
			when '<='
				calculo = calcula2(v[0], objeto, pago) <= calcula2(v[1], objeto, pago)
			when '=='
				calculo = calcula2(v[0], objeto, pago) == calcula2(v[1], objeto, pago)
			when '!='
				calculo = calcula2(v[0], objeto, pago) != calcula2(v[1], objeto, pago)
			end
			formula = formula.gsub($1, calculo.to_s)
		end
		formula
	end

	def calcula2(formula, objeto, pago)
		if formula.blank?
			0
		else
			# reemplaza los paréntesis de dentro hacia afuera hasta que no queden
			formula = parentesis_less(formula, objeto, pago)
			formula = ternario_less(formula, objeto, pago)
			formula = funciones_less(formula, objeto, pago)
			formula = lookup_less(formula, objeto, pago)
			formula = datos_less(formula, objeto, pago)
			formula = operaciones_1_less(formula, objeto, pago)
			formula = operaciones_2_less(formula, objeto, pago)
			formula = logica_math_less(formula, objeto, pago)

			if formula.split(' ').length == 1
				get_token_value(formula, objeto, pago)
			end
		end
	end

	def get_token_value(token, objeto, pago)
		libreria = objeto.tar_tarifa.blank? ? [] : objeto.tar_tarifa.tar_formulas
		if token.strip[0] == '#' #Valor de la causa
			case token.strip
			when '#tarifa_variable'
				#no agrego 'honorarios' porque se entiende que es lo que aplica
				get_honorarios_variable(objeto, pago, 'proporcional')

			when '#cuantia_pesos'
				get_total_cuantia(objeto, 'real')

			when '#cuantia_pesos_honorarios'
				# Si se trata de un pago que ya fue autorizado, se rescata la cuantía de TarCalculo
				cuantia_calculo = get_cuantia_calculo(objeto, pago)
				cuantia_calculo.blank? ? get_total_cuantia(objeto, 'tarifa') : cuantia_calculo
			when '#cuantia_uf'
				get_total_cuantia_uf(objeto, pago, 'real')

			when '#cuantia_uf_honorarios'
				# Si se trata de un pago que ya fue autorizado, se rescata la cuantía de TarCalculo
				cuantia_calculo = get_cuantia_calculo(objeto, pago)
				cuantia_calculo.blank? ? get_total_cuantia_uf(objeto, pago, 'tarifa') : (cuantia_calculo / get_uf_calculo(objeto, pago))

			when '#monto_pagado'
				objeto.monto_pagado.blank? ? 0 : objeto.monto_pagado
			when '#monto_pagado_uf'
				objeto.monto_pagado_uf(pago)
			when '#facturado_pesos'
				objeto.facturado_pesos
			when '#facturado_uf'
				objeto.facturado_uf
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

	# **************************** Métodos usados para la evaluación y el despliegue de pagos
	# VALORES de tar_valor cuantia que sirven para despliegue sin necesidad de otras variables
	# tipo : { 'real', 'tarifa'}
	def vlr_cuantia(tar_valor_cuantia, tipo)
		formula = tipo == 'real' ? tar_valor_cuantia.formula : tar_valor_cuantia.formula_honorarios
		valor = tipo == 'real' ? tar_valor_cuantia.valor : tar_valor_cuantia.valor_tarifa
		if /\$Remuneración/.match?(formula)
			demandante = tar_valor_cuantia.demandante
			rem = demandante.blank? ? 0 : demandante.remuneracion
			formula = formula.gsub('$Remuneración', rem.to_s)
		end
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

	def get_total_cuantia(causa, tipo)
		tipo == 'real' ? causa.valores_cuantia.map {|vlr_cnt| vlr_cuantia(vlr_cnt, 'real')}.sum : causa.valores_cuantia.map {|vlr_cnt| vlr_tarifa(vlr_cnt)}.sum
	end

	def get_total_cuantia_uf(causa, pago, tipo)
		uf = get_uf_calculo(causa, pago)
		uf.blank? ? 0 : (get_total_cuantia(causa, tipo) / uf)
	end

	def get_cuantia_calculo(causa, pago)
		tar_calculo = get_tar_calculo(causa, pago)
		tar_calculo.blank? ? nil : tar_calculo.cuantia
	end

	# Sirve para causa / asesoria
	def get_tar_calculo(objeto, pago)
		objeto.class.name == 'Causa' ? objeto.calculos.find_by(tar_pago_id: pago.id) : objeto.calculo
	end

	# Sirve para causa / asesoria
	def get_tar_facturacion(objeto, pago)
		objeto.class.name == 'Causa' ? objeto.facturaciones.where(tar_pago_id: pago.id).first : objeto.facturacion
	end

	# Sirve para causa / asesoria
	def get_tar_uf_facturacion(objeto, pago)
		objeto.class.name == 'Causa' ? objeto.uf_facturaciones.where(tar_pago_id: pago.id).first : objeto.facturacion
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
	def get_fecha_calculo(causa, pago)
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

	# UF de cálculo tarifa
	# Sirve para Causa / Asesoría
	def get_uf_calculo(objeto, pago)
		fecha_uf = objeto.class.name == 'Causa' ? get_fecha_calculo(objeto, pago) : (objeto.uf_facturacion.present? ? objeto.uf_facturacion.fecha : objeto.created_at )
		fecha_uf.blank? ? nil : uf_fecha( fecha_uf )
	end

	# Monto en pesos de TarCalculo o TarFacturación
	# Sirve para Causa / Asesoría : objeto = {tar_calculo, tar_facturacion}; owner = {causa, asesoria}
	def get_monto_calculo_pesos(objeto, owner, pago)
		uf = get_uf_calculo(owner, pago)
		puts "******************************************* get_monto_calculo_pesos"
		puts uf
		puts objeto.class.name
		puts objeto.moneda
		puts objeto.monto
		objeto.moneda == 'Pesos' ? objeto.monto : (get_uf_calculo(owner, pago).blank? ? 0 : (objeto.monto * get_uf_calculo(owner, pago)))
	end

	# Monto en UF de TarCalculo o TarFacturación
	# Sirve para Causa / Asesoría : objeto = {tar_calculo, tar_facturacion}; owner = {causa, asesoria}
	def get_monto_calculo_uf(objeto, owner, pago)
		uf = get_uf_calculo(owner, pago)
		puts "******************************************* get_monto_calculo_uf"
		puts uf
		puts objeto.class.name
		puts objeto.moneda
		puts objeto.monto
		['UF', '', nil].include?(objeto.moneda) ? objeto.monto : (get_uf_calculo(owner, pago).blank? ? 0 : objeto.monto / get_uf_calculo(owner, pago))
	end

    # Se usa en el ENCABEZADO del DETALLE DE UN PAGO
    # 1.- Si hay Tar Calculo, saca la info de ahí
    # 1.- Si no se cumple 1.- y hay TarFacturacion, saca la info de ahí
    # 3.- Si no se cumplen 1.- ni 2.- Se calcula para deplegar el monto para aprobación
    # Sirve para Causa / Asesoria: cambiamos causa por objeto
    def get_v_calculo_tarifa(objeto, pago)
    	tar_facturacion = get_tar_facturacion(objeto, pago)
    	tar_calculo = get_tar_calculo(objeto, pago)
    	uf_calculo = get_uf_calculo(objeto, pago)
    	if objeto.class.name == 'Causa'
	    	# Si en una tarifa de cuantía, no hay cuantía o no hay UF para un pago que la requiere.
	    	if (pago.valor.blank? and objeto.valores_cuantia.empty?) or (uf_calculo.blank? and pago.requiere_uf)
	    		monto_uf = 0
	    		monto_pesos = 0
	    	elsif tar_calculo.blank? and tar_facturacion.blank?
	    		monto = pago.valor.blank? ? (pago.formula_tarifa.blank? ? 0 : calcula2(pago.formula_tarifa, objeto, pago)) : pago.valor
		        monto_pesos = pago.moneda == 'Pesos' ? monto : ( uf_calculo.blank? ? 0 : monto * uf_calculo )
		        monto_uf = pago.moneda == 'UF' ? monto : ( uf_calculo.blank? ? 0 : monto / uf_calculo )
	    	else
	    		cll_fctn = tar_calculo.present? ? tar_calculo : tar_facturacion
	    		monto_pesos = get_monto_calculo_pesos(cll_fctn, objeto, pago)
	    		monto_uf = get_monto_calculo_uf(cll_fctn, objeto, pago)
	    	end
	    else
    		cll_fctn = tar_calculo.present? ? tar_calculo : tar_facturacion
    		monto_pesos = get_monto_calculo_pesos(cll_fctn, objeto, pago)
    		monto_uf = get_monto_calculo_uf(cll_fctn, objeto, pago)
    	end
    	[monto_uf, monto_pesos]
    end

	def origen_fecha_calculo(causa, pago)
		tar_uf_facturacion = get_tar_uf_facturacion(causa, pago)
		tar_calculo = get_tar_calculo(causa, pago)
		tar_facturacion = get_tar_facturacion(causa, pago)
		tar_uf_facturacion.present? ? 'TarUfFacturacion' : ( tar_calculo.present? ? 'TarCalculo' : ( tar_facturacion.present? ? 'TarFacturacion' : 'Today' ) )
	end

    # Se usa en Aprobación
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

	# MÉTODOS PARA CALCULAR HONORARIO VARIABLE
	def get_vctr_prcntgs(causa)
		causa.valores_cuantia.map {|vc| vc.porcentaje_variable}.uniq.sort
	end

	def get_subtotales_cuantia(causa, pago)
		sbtts_cnt = {}
		causa.valores_cuantia.each do |vc|
			prcntg = vc.porcentaje_variable
			if sbtts_cnt[vc.porcentaje_variable].blank?
				sbtts_cnt[prcntg] = vlr_tarifa(vc)
			else
				sbtts_cnt[prcntg] += vlr_tarifa(vc)
			end
		end
		sbtts_cnt
	end

	def get_factor_ahorro(causa, pago)
		vctr = get_vctr_prcntgs(causa)
		sbtts = get_subtotales_cuantia(causa, pago)
		cuantia_calculo = get_cuantia_calculo(causa, pago)
		cuantia_honorarios = cuantia_calculo.blank? ? get_total_cuantia(causa, 'tarifa') : cuantia_calculo
		fctr = {}
		vctr.each do |perc|
			fctr[perc] = sbtts[perc] / cuantia_honorarios
		end
		fctr
	end

	def get_honorarios_variable(causa, pago, criterio)
		vctr = get_vctr_prcntgs(causa)
		sbtts = get_subtotales_cuantia(causa, pago)
		fctrs = get_factor_ahorro(causa, pago)
		monto_pagado = causa.monto_pagado.blank? ? 0 : causa.monto_pagado
		hnr = 0
		if criterio == 'proporcional'
			vctr.each do |perc|
				ahorro = sbtts[perc] - monto_pagado * fctrs[perc]
				hnr += ahorro * (perc / 100)
			end
			hnr
		else
			vector = criterio == 'menor' ? vctr : vctr.reverse
			pagado = monto_pagado
			hnr = 0
			vector.each do |perc|
				if pagado < sbtts[perc]
					hnr += sbtts[perc] - pagado
					pagado = 0
				else
					pagado = pagado - sbtts[perc]
				end
			end
		end
	end
end