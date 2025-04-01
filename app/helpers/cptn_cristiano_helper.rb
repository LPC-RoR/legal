module CptnCristianoHelper

	def is_model?(str)
		str == str.camelize
	end

	def is_controller?(str)
		str == str.tableize
	end

	# controlador SIN prefijo por alias
	def get_controller(controller)
		simple = controller.split('-').last
		app_alias[simple].blank? ? simple : app_alias[simple]
	end

	# excepciones de nombres de un modelo
	def m_excepciones
		{
			'TarUfSistema' => 'Uf del día',
			'TribunalCorte' => 'Juzgado',
			'TarDetalleCuantia' => 'Item de cuantía',
			'TarUfFacturacion' => 'UF de cálculo',
			'TarTarifa' => 'Tarifa de Causa',
			'TarServicio' => 'Tarifa de Asesoría',
			'TipoCausa' => 'Etapa',
			'Tema' => 'Materia',
			'AutTipoUsuario' => 'Tipo de Usuario',
			'ControlDocumento' => 'Documento controlado',
			'RepDocControlado' => 'Documento controlado',
			'HmPagina' => 'Página',
			'HmParrafo' => 'Párrafo',
			'LglDocumento' => 'Documento legal',
			'Region' => 'Región',
			'ProDtllVenta' => 'Producto de la Empresa',
			'KrnInvDenuncia' => 'Investigador',
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
			'facturacion' => 'facturación',
			'conciliacion' => 'conciliación',
			'articulo' => 'artículo',
			'aprobacion' => 'aprobación',
			'region' => 'región'
		}
	end

	# prefijos de modelos con scope
	def scopes
		/^tar_|^app_|^h_|^st_|^ind_|^m_|^blg_|^dt_|^org_|^age_|^hm_|^lgl_|^pro_|^krn_|^ctr_|^cal_|^rep_|^hlp_/
	end

	def str_name(str_source)
		cntrllr = is_model?(str_source) ? str_source.tableize : str_source
		no_scope = cntrllr.match(scopes) ? cntrllr.gsub(scopes, '') : cntrllr
		no_scope.singularize.humanize.split.map {|word| corrige(word.downcase)}.join(' ').capitalize
	end

	def get_excpcns(str_source)
		mdl = is_model?(str_source) ? str_source : str_source.classify
		m_excepciones.keys.include?(mdl) ? m_excepciones[mdl] : nil
	end

	def to_name(source)
		str_source = source.class.name == 'String' ? source : source.class.name
		get_excpcns(str_source).blank? ? str_name(str_source) : get_excpcns(str_source)
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

	#**********************************************************************   APP   *************************************************************

	def app_alias 
		{
			'alias' => 'controlador'
		}
	end

end