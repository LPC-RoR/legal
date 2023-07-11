module Conciliacion
	extend ActiveSupport::Concern

	def carga_cartola(conciliacion)

		# PROVISIONAL : Toma el primer formato, quizá en prósima versión se pueda elegir formato.
		formato = conciliacion.m_cuenta.m_formato
		cuenta = conciliacion.m_cuenta

		estado = 'encabezado'

		xlsx = Roo::Spreadsheet.open("#{Rails.root}/public/#{conciliacion.m_conciliacion.url}")


		xlsx.each_with_index do |linea, index|
			# linea[0] : columna A; linea[1] : columna B ...

			case estado
			when 'encabezado'
				# carga datos que se recuperan de la línea
				datos_ids = formato.m_datos.map {|dato| dato.id if dato.fila == index+1}.compact
				datos = MDato.where(id: datos_ids)

				# se crean los datos
				unless datos.empty?
					datos.each do |dato|
						crea_m_valor(conciliacion, dato, linea)
					end
				end

				# se cambia el estado si correponde
				if  condicion_cartola?(index, linea, formato.inicio)
					conciliacion.m_registros.destroy_all
					estado = 'cartola' 
				end

			when 'cartola'
				unless condicion_cartola?(index, linea, formato.termino)
					crea_m_registro(conciliacion, linea, index, formato)
				else
					estado = 'termino'
				end
			when 'termino'
				puts "Término linea #{index + 1}"
			end

		end
	end

	def condicion_cartola?(indice, linea, inicio)
		# A | Valor
		columna = inicio.split('|')[0].strip
		valor = inicio.split('|')[1].strip

		linea[columna.ord - 'A'.ord] == valor
	end

	def crea_m_valor(conciliacion, dato, linea)
		m_valor = conciliacion.m_valores.find_by(m_valor: dato.m_dato)
		m_valor.delete unless m_valor.blank?

		celda = linea[dato.columna.ord - 'A'.ord]

		valor = dato.split_tag.blank? ? celda : celda.split(dato.split_tag)[1]
		conciliacion.m_valores.create(m_valor: dato.m_dato, orden: dato.orden, tipo: dato.tipo, valor: remove_html_tags(valor))
	end

	def remove_html_tags(texto)
		texto.class.name == 'String' ? texto.gsub(/<\/?[^>]+>/, '').strip : texto
	end

	def crea_m_registro(conciliacion, linea, indice, formato)
		elementos = formato.m_elementos

		orden = indice

		fecha = get_elemento_lista(elementos, linea, 'fecha')
		glosa_banco = get_elemento_lista(elementos, linea, 'glosa_banco')
		documento = get_elemento_lista(elementos, linea, 'documento')
		monto = get_elemento_lista(elementos, linea, 'monto')
		cargo_abono = traduce_abono_cargo(get_elemento_lista(elementos, linea, 'cargo_abono'))
		saldo = get_elemento_lista(elementos, linea, 'saldo')
		reg = conciliacion.m_registros.create(orden: orden, fecha: fecha, glosa_banco: glosa_banco, documento: documento, monto: monto, cargo_abono: cargo_abono, saldo: saldo)

		modelo = conciliacion.m_cuenta.m_banco.m_modelo

		unless reg.fecha.blank?
			clave = reg.fecha.year * 100 + reg.fecha.month
			nombre_periodo = "#{reg.fecha.year} #{nombre_mes(reg.fecha.month)}"

			periodo = modelo.m_periodos.find_by(clave: clave)

			periodo = modelo.m_periodos.create(m_periodo: nombre_periodo, clave: clave) if periodo.blank?

			periodo.m_registros << reg
		end

	end

	def get_elemento_lista(elementos, linea, registro)
		elemento = elementos.find_by(registro: registro)
		elemento.blank? ? nil : linea[elemento.columna.ord-'A'.ord]
	end

	def nombre_mes(mes_numero)
		meses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
		meses[mes_numero-1]
	end

	def abono_names
		['A', 'Abono']
	end

	def traduce_abono_cargo(texto)
		texto.blank? ? '-' : (abono_names.include?(texto) ? 'Abono' : 'Cargo')
	end

end