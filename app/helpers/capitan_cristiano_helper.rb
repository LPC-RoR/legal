module CapitanCristianoHelper

	def x_scope(string)
		if string.tableize.match(/^tar_|^app_|^ĥ_|^st_/)
			string.classify.gsub(/^Tar|^App|^H|^St/, '')
		else
			string.classify
		end
	end

	## ------------------------------------------------------- CRISTIANO BASE
	## Actualización : SIEMPRE ENTREGA SINGULAR CAPITALIZADO
	def cristiano(text_input)
		clase = text_input.split(':').last.classify

		# EXCEPCIONES AL MANEJO GENERAL
		if clase == 'TarUfSistema'
			'UF del sistema'
		elsif clase == 'SbLista'
			'Menú lateral'
		elsif clase == 'SbElemento'
			'Elemento del menú lateral'
		elsif clase == 'TarHora'
			'Tarifa Hora'
		else
			text = x_scope(clase)
			if ['created_at'].include?(text)
				'Fecha'
			elsif text == 'DetalleCuantia'
				'Detalle Cuantía'
			elsif text == 'ValorCuantia'
				'Valor Cuantía'
			else
				cword(text)
			end
		end
			
	end

	def cword(string)
		text = string.gsub(/^tar_|^app_|^h_|^st_/, '').humanize.capitalize
		if text == 'Nomina'
			'Nómina'
		elsif text == 'Observacion'
			'Observación'
		elsif text == 'Formula'
			'Fórmula'
		elsif text == 'Consultoria'
			'Consultoría'
		elsif text == 'Codigo'
			'Código'
		elsif text == 'Descripcion'
			'Descripción'
		elsif text == 'Facturacion'
			'Facturación'
		elsif text == 'Detalle cuantia'
			'Detalle cuantía'
		else
			text
		end
	end

end