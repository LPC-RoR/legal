module CptnTablaAppHelper
#**********************************************************************   APP   *************************************************************

	def app_no_th_controllers
		[]
	end

	def app_new_button_conditions(controller)
		if ['tar_tarifas', 'tar_servicios', 'tar_valores', 'tar_horas', 'registros', 'reg_reportes', 'tar_valor_cuantias', 'tar_facturas', 'tar_uf_facturaciones', 'item-m_registros', 'periodo-m_registros', 'm_registros', 'general-m_periodos', 'perfil-m_periodos'].include?(controller)
			false
		elsif ['tar_facturaciones'].include?(controller)
			dog? and controller_name == 'tar_facturas'
		elsif ['causas', 'consultorias'].include?(controller)
			controller_name == 'st_bandejas'
		else
			true
		end
	end

	def app_crud_conditions(objeto, btn)
		if ['RegReporte', 'MRegistro'].include?(objeto.class.name)
			false
		elsif [].include?(objeto.class.name)
			admin?
		elsif ['TarFacturacion'].include?(objeto.class.name)
			(controller_name == 'tar_facturas') and objeto.facturable.blank?
		elsif ['TarFactura'].include?(objeto.class.name)
			btn == 'Eliminar' and objeto.tar_facturaciones.empty?
		elsif ['TarPago', 'TarFormula'].include?(objeto.class.name)
			controller_name == 'tar_tarifas'
		else
			case objeto.class.name
			when 'TarValorCuantia'
				controller_name == 'causas' and @options[:menu] == 'Cuantía'
			when 'Registro'
				admin? and objeto.estado == 'ingreso'
			else
				true
			end
		end
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