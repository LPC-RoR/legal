module CptnCristianoHelper

	# controlador SIN prefijo por alias
	def get_controller(controller)
		simple = controller.split('-').last
		app_alias[simple].blank? ? simple : app_alias[simple]
	end

	# excepciones de nombres de un modelo
	def m_excepciones
		{
			'TarUfSistema' => 'Uf del sistema',
			'SbLista' => 'Menú lateral',
			'SbElemento' => 'Elemento del menú lateral',
			'TarHora' => 'Tarifa en Horas'
		}
	end

	# excepciones de campos
	def f_excepciones 
		{
			'created_at' => 'fecha',
			'sha1' => 'clave'
		}
	end

	# corrección de palabras
	def correcciones 
		{
			'cuantia' => 'cuantía',
			'nomina' => 'nómina',
			'observacion' => 'observación',
			'formula' => 'fórmula',
			'consultoria' => 'consultoría',
			'codigo' => 'código',
			'descripcion' => 'descripción',
			'facturacion' => 'facturación'
		}
	end

	# prefijos de modelos con scope
	def scopes
		/^tar_|^app_|^h_|^st_|^ind_/
	end

	# nombre que se desplega de un controlador
	def c_to_name(controller)
		if m_excepciones.keys.include?(controller.classify)
			# Manejo de excepciones
			m_excepciones[controller.classify]
		else
			# Manejo de scopes
			text = controller.match(scopes) ? controller.gsub(scopes, '') : controller
			# corrige acentos
			text.humanize.split.map {|word| corrige(word.downcase)}.join(' ').capitalize
		end
	end

	# nombre que se desplega de un controlador
	def m_to_name(modelo)
		if m_excepciones.keys.include?(modelo)
			m_excepciones[modelo]
		else
			c_to_name(modelo.tableize)
		end
	end

	# corrige palabras
	def corrige(word)
		correcciones.keys.include?(word) ? correcciones[word] : word
	end

	# corrige nombres de campos
	def corrige_campo(field)
		if f_excepciones.keys.include?(field)		
			f_excepciones[field]
		else
			text = field.match(scopes) ? field.gsub(scopes, '') : field
			text.humanize.split.map {|word| corrige(word.downcase)}.join(' ').capitalize
		end
	end

end