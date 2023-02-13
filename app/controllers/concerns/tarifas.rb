module Tarifas

	# Encuentra el detalle de trifaa de un CÓDIGO particular
	# owner = CAUSA/CONSULTORIA
	def get_tar_detalle(owner, codigo)
		owner.tar_tarifa.tar_detalles.find_by(codigo: codigo)
	end

	# Encuaantra el valor ingresado para un DETALLE DE TARIFA correspondiente a un CÓDIGO
	# owner = CAUSA/CONSULTORIA
	def get_tar_valor(owner, codigo)
		owner.valores.empty? ? nil : owner.valores.find_by(codigo: codigo)
	end

	# Obtiene lista de OTROS
	# Son los valores en los que el código es ''
	# owner = CAUSA/CONSULTORIA
	def get_otros(owner)
		owner.valores.empty? ? owner.valores : owner.valores.where(codigo: '')
	end

	def get_suma(formula)
		formula.split(' ').each do |elem|
		end
	end

	def get_valor_formula(causa, formula)
		causa.tar_tarifa.tar_detalles.order(:orden).each do |tar_detalle|
			if formula.include?(tar_detalle.codigo)

				tar_detalle_elem = get_tar_detalle(causa, tar_detalle.codigo)
				valor = 0
				case tar_detalle_elem.tipo
				when 'valor'
					tar_valor = get_tar_valor(causa, tar_detalle_elem.codigo)
					formula.gsub( tar_detalle.codigo, (tar_valor.blank? ? '0' : tar_valor.d_valor.to_s))
				when 'otros'
					valor = 0
					otros = get_otros(causa)
					unless otros.empty?
						otros.each do |detalle_otro|
							valor += detalle_otro.d_valor
						end
					end
					formula.gsub(tar_detalle.codigo, valor.to_s)
				when 'formula'
#avi					formula = formula.gsub(tar_detalle.codigo, get_valor_formula(causa, tar_detalle_elem.formula) )
				end

			end
		end
		send(formula)
	end

	# Evalua una SUMA
	# owner = CAUSA/CONSULTORIA
	def eval_suma(owner, formula)
		suma = 0
		formula.split(' ').each do |termino|
			if number?(termino)
				suma += termino.to_f
			else
				suma += do_eval(owner, termino)
			end
		end
		suma
	end

	# Evalua un PRODUCTO
	# owner = CAUSA/CONSULTORIA
	def eval_producto(owner, formula)
		producto = 1
		formula.split(' ').each do |termino|
			if number?(termino)
				producto *= termino.to_f
			else
				producto *= do_eval(owner, termino)
			end
		end
		producto
	end

	# Evalua un MÁXIMO
	# owner = CAUSA/CONSULTORIA
	def eval_maximo(owner, formula)
		valores = formula.split(' ')
		valor1 = number?(valores[0]) ? valores[0].to_f : do_eval(owner, valores[0])
		valor2 = number?(valores[1]) ? valores[1].to_f : do_eval(owner, valores[1])

		valor1 > valor2 ? valor1 : valor2
	end

	# Evalua un CONDICIONAL
	# owner = CAUSA/CONSULTORIA
	def eval_condicional(owner, formula)
		cond_opciones = formula.split('?')
		condicion = cond_opciones[0].split(' ')
		opciones = cond_opciones[1].split(':')
		opcion_v = opciones[0]
		opcion_f = opciones[1]

		case condicion[0].strip
		when 'menor_igual'
			valor1 = number?(condicion[1].strip) ? condicion[1].to_f : do_eval(owner, condicion[1])
			valor2 = number?(condicion[2].strip) ? condicion[2].to_f : do_eval(owner, condicion[2])
			test_condicion = valor1 <= valor2
		end
		test_condicion ? (number?(opcion_v.strip) ? opcion_v.to_f : do_eval(owner, opcion_v.strip)) : (number?(opcion_f.strip) ? opcion_f.to_f : do_eval(owner, opcion_f.strip))
	end

	# Evalua un PISO TOPE
	# owner = CAUSA/CONSULTORIA
	def eval_piso_tope(owner, formula)
		elementos = formula.split(' ')
		valor = number?(elementos[0]) ? elementos[0].to_f : do_eval(owner, elementos[0])
		piso = number?(elementos[1]) ? elementos[1].to_f : do_eval(owner, elementos[1])
		tope = number?(elementos[2]) ? elementos[2].to_f : do_eval(owner, elementos[2])
		aplica_piso = (valor < piso ? piso : valor)
		aplica_piso > tope ? tope : aplica_piso
	end

	# Evalua AHORRO
	# owner = CAUSA/CONSULTORIA
	def eval_ahorro(owner, formula)
		elementos = formula.split(' ')
		demandado = number?(elementos[0]) ? elementos[0].to_f : do_eval(owner, elementos[0])
		pagado = number?(elementos[1]) ? elementos[1].to_f : do_eval(owner, elementos[1])
		demandado > pagado ? demandado - pagado : 0
	end

	# Evalua el valor de una tarifa normal de CAUSA/COONSULTORIA
	# owner = CAUSA/CONSULTORIA
	def do_eval(owner, codigo)
		tar_detalle = get_tar_detalle(owner, codigo)
		case tar_detalle.tipo
		when 'valor'
			tar_valor = get_tar_valor(owner, codigo)
			tar_valor.blank? ? 0 : tar_valor.d_valor
		when 'otros'
			otros = 0
			detalle_otros = get_otros(owner)
			unless detalle_otros.empty?
				detalle_otros.each do |detalle_otro|
					otros += detalle_otro.d_valor
				end
			end
			otros
		when 'suma'
			eval_suma(owner, tar_detalle.formula)
		when 'producto'
			eval_producto(owner, tar_detalle.formula)
		when 'máximo'
			eval_maximo(owner, tar_detalle.formula)
		when 'condicional'
			eval_condicional(owner, tar_detalle.formula)
		when 'piso_tope'
			eval_piso_tope(owner, tar_detalle.formula)
		when 'ahorro'
			eval_ahorro(owner, tar_detalle.formula)
		end
	end

	def tarifa_array(causa)
		tar_array = []
		# recorrer los detalles de la tarifa
		causa.tar_tarifa.tar_detalles.order(:orden).each do |detalle_tarifa|
			unless detalle_tarifa.esconder
				case detalle_tarifa.tipo
				when 'valor'
					detalle_valor = get_tar_valor(causa, detalle_tarifa.codigo)
					tar_array << [detalle_valor.d_detalle, detalle_valor.d_valor, false ] unless detalle_valor.blank?
				when 'otros'
					detalle_otros = get_otros(causa)
					unless detalle_otros.empty?
						detalle_otros.each do |detalle_otro|
							tar_array << [detalle_otro.detalle, detalle_otro.valor, false]
						end
					end
				when 'suma'
					tar_array << [detalle_tarifa.detalle, eval_suma(causa, detalle_tarifa.formula), detalle_tarifa.total]
				when 'producto'
					tar_array << [detalle_tarifa.detalle, eval_producto(causa, detalle_tarifa.formula), detalle_tarifa.total]
				when 'máximo'
					tar_array << [detalle_tarifa.detalle, eval_maximo(causa, detalle_tarifa.formula), detalle_tarifa.total]
				when 'condicional'
					tar_array << [detalle_tarifa.detalle, eval_condicional(causa, detalle_tarifa.formula), detalle_tarifa.total]
				when 'piso_tope'
					tar_array << [detalle_tarifa.detalle, eval_piso_tope(causa, detalle_tarifa.formula), detalle_tarifa.total]
				when 'ahorro'
					tar_array << [detalle_tarifa.detalle, eval_ahorro(causa, detalle_tarifa.formula), detalle_tarifa.total]
				end
			end
		end

		tar_array
	end
end