module CptnTarifasHelper

	def calcula(formula, libreria, causa)

		while formula.match(/\([^()]*\)/) do
			segmento = formula.match(/\([^()]*\)/)[0]
			formula = formula.gsub(segmento, calcula(segmento.gsub(/\(/, '').gsub(/\)/, '').strip, libreria, causa).to_s)
		end

		# aqui tengo fórmulas sin parentesis
		# hay que reconocer operaciones por pioridad = complejidad
		if formula.match(/[^\?:]+\?[^\?:]+:[^\?:]+/)
			# OPERADOR TERNRIO
			exp = formula.match(/(?<condicion>[^\?:]+)\?(?<verdadero>[^\?:]+):(?<falso>[^\?:]+)/)
			eval_condicion(exp[:condicion], libreria, causa) ? eval_elemento(exp[:verdadero], libreria, causa) : eval_elemento(exp[:falso], libreria, causa)
		elsif formula.match(/max\[[^\[\]]+,[^\[\]]+/)
			# MAXIMO
			exp = formula.match(/max\[([^\[\]]+),([^\[\]]+)/)
			e_1 = eval_elemento(exp[1], libreria, causa)
			e_2 = eval_elemento(exp[2], libreria, causa)
			e_1 <= e_2 ? e_2 : e_1
		elsif formula.match(/rango\[[^\[\]]+,[^\[\]]+/)
			# RANGO
			exp = formula.match(/rango\[([^\[\]]+),([^\[\]]+),([^\[\]]+)/)
			valor = eval_elemento(exp[1], libreria, causa)
			inferior = eval_elemento(exp[2], libreria, causa)
			superior = eval_elemento(exp[3], libreria, causa)
			
			valor > superior ? superior : (valor < inferior ? inferior : valor)
		elsif formula.match(/[^\+]+\+[^\+]+/)
			# SUMA
			exp = formula.match(/([^\+]+)\+([^\+]+)/)
			eval_elemento(exp[1], libreria, causa) + eval_elemento(exp[2], libreria, causa)
		elsif formula.match(/[^\+]+\-[^\+]+/)
			# RESTA
			exp = formula.match(/([^\+]+)\-([^\+]+)/)
			eval_elemento(exp[1], libreria, causa) - eval_elemento(exp[2], libreria, causa)
		elsif formula.match(/[^\+]+\*[^\+]+/)
			# PRODUCTO
			exp = formula.match(/([^\+]+)\*([^\+]+)/)
			eval_elemento(exp[1], libreria, causa) * eval_elemento(exp[2], libreria, causa)
		elsif formula.match(/[^\+]+\/[^\+]+/)
			# DIVISION
			exp = formula.match(/([^\+]+)\/([^\+]+)/)
			eval_elemento(exp[1], libreria, causa) / eval_elemento(exp[2], libreria, causa)
		end
	end

	def eval_condicion(condicion, libreria, causa)

		# Manejo de paréntesis
		# del resultado de esto puede salir un true, false

		while condicion.match(/\([^()]*\)/) do
			segmento = condicion.match(/\([^()]*\)/)[0]
			condicion = condicion.gsub(segmento, eval_condicion(segmento.gsub(/\(/, '').gsub(/\)/, '').strip, libreria, causa).to_s)
		end

		# manejo de & u |
		if condicion.match(/[^&]+\&[^&]+/)
			exps = condicion.split('&')
			cond = true
			exps.each do |e_cond|
				cond = (cond and eval_condicion(e_cond, libreria, causa))
			end
			cond
		elsif condicion.match(/[^|]+\|[^|]+/)
			exps = condicion.split('|')
			cond = false
			exps.each do |e_cond|
				cond = (cond or eval_condicion(e_cond, libreria, causa))
			end
			cond
		elsif condicion.match(/[^<=]+<=[^<=]+/)
			# <=
			exp = condicion.match(/(?<menor>[^<=]+)<=(?<mayor>[^<=]+)/)
			eval_elemento(exp[:menor], libreria, causa) <= eval_elemento(exp[:mayor], libreria, causa)
		elsif condicion.match(/[^>=]+>=[^>=]+/)
			# >=
			exp = condicion.match(/(?<mayor>[^>=]+)>=(?<menor>[^>=]+)/)
			eval_elemento(exp[:mayor], libreria, causa) >= eval_elemento(exp[:menor], libreria, causa)
		elsif condicion.match(/[^<]+<[^<]+/)
			# <
			exp = condicion.match(/(?<menor>[^<]+)\<(?<mayor>[^<]+)/)
			eval_elemento(exp[:menor], libreria, causa) < eval_elemento(exp[:mayor], libreria, causa)
		elsif condicion.match(/[^>]+>[^>]+/)
			# >
			exp = condicion.match(/(?<mayor>[^>]+)>(?<menor>[^>]+)/)
			eval_elemento(exp[:mayor], libreria, causa) > eval_elemento(exp[:menor], libreria, causa)
		elsif condicion.match(/[^=]+=[^=]+/)
			# =
			exp = condicion.match(/(?<mayor>[^=]+)=(?<menor>[^=]+)/)
			eval_elemento(exp[:mayor], libreria, causa) == eval_elemento(exp[:menor], libreria, causa)
		else 
			calcula(condicion, libreria, causa)
		end
	end

	def eval_elemento(elemento, libreria, causa)
		if elemento.strip[0] == '#' #Valor de la causa
			case elemento.strip
			when '#uf'
				TarUfSistema.find_by(fecha: DateTime.now.to_date).valor
			when '#cuantia_pesos'
				causa.cuantia_pesos
			when '#cuantia_uf'
				causa.cuantia_uf
			when '#monto_sentencia'
				causa.cuantia_uf
			end
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
