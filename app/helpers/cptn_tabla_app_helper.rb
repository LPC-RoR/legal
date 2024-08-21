module CptnTablaAppHelper
#**********************************************************************   APP   *************************************************************

	def h_new
		{
			'tar_valor_cuantias' => @objeto.demandantes.any?
		}
	end

	def new?(source)
		cntrllr = source.class.name == 'String' ? source : source.class.name.tableize
		h_new[cntrllr] == nil ? true : h_new[cntrllr]
	end

	def sortable_fields
		{
			'controller' => ['campo1', 'campo2']
		}
	end

	# En modelo.html.erb define el tipo de fila de tabla
	# Se usa para marcar con un color distinto la fila que cumple el criterio
	def table_row_type(objeto)
		case objeto.class.name
		when 'Publicacion'
			if usuario_signed_in?
				(objeto.carpetas.ids & perfil_activo.carpetas.ids).empty? ? 'default' : 'dark'
			else
				'default'
			end
		else
			'default'
		end
	end

	def icon_fields(campo, objeto)
		if objeto.class.name == 'Registro'
			if campo == 'fecha'
				case objeto.tipo
				when 'Informe'
				"bi bi-file-earmark-check"
				when 'Documento'+
				"bi bi-file-earmark-pdf"
				when 'Llamada telefónica'
				"bi bi-telephone"
				when 'Mail'
				"bi bi-envelope-at"
				when 'Reporte'
				"bi bi-file-earmark-ruled"
				end
			end
		end
	end

end