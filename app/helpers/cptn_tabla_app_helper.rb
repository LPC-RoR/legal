module CptnTablaAppHelper
#**********************************************************************   APP   *************************************************************

	def app_no_th_controllers
		['tar_uf_facturaciones']
	end

	def app_new_button_conditions(controller)
		if ['tar_tarifas', 'tar_servicios', 'tar_valores', 'tar_horas', 'registros', 'reg_reportes', 'tar_valor_cuantias', 'ingreso-tar_facturas', 'facturada-tar_facturas', 'pagada-tar_facturas', 'tar_uf_facturaciones', 'tar_aprobaciones', 'tar_uf_sistemas', 'tar_detalle_cuantias'].include?(controller)
			false
		elsif ['tar_facturas', 'por_emitir-tar_facturas', 'en_cobranza-tar_facturas', 'tar_pagos', 'tar_formulas'].include?(controller)
			false
		elsif ['tar_facturaciones', 'sin_aprobacion-tar_facturaciones', 'sin_facturar-tar_facturaciones'].include?(controller)
			false
		elsif ['item-m_registros', 'periodo-m_registros', 'm_registros', 'm_cuentas', 'm_periodos', 'm_bancos'].include?(controller)
			false
		elsif ['clientes', 'activo_empresa-clientes', 'activo_sindicato-clientes', 'activo_trabajador-clientes', 'baja-clientes'].include?(controller)
			false
		elsif ['causas', 'proceso-causas', 'terminada-causas', 'sin_cuantia-causas', 'sin_facturar-causas', 'en_proceso-causas'].include?(controller)
			false
		elsif ['tribunal_cortes', 'tipo_causas'].include?(controller)
			false
		elsif ['asesorias', 'proceso-asesorias', 'terminada-asesorias'].include?(controller)
			false
		else
			true
		end
	end

	def app_crud_conditions(objeto, btn)
		if ['RegReporte', 'TarFacturacion'].include?(objeto.class.name)
			false
		elsif ['Causa'].include?(objeto.class.name)
			objeto.estado == 'ingreso'
		elsif [].include?(objeto.class.name)
			admin?
		elsif ['TarFactura'].include?(objeto.class.name)
			btn == 'Eliminar' and objeto.tar_facturaciones.empty?
		elsif ['TarPago', 'TarFormula'].include?(objeto.class.name)
			controller_name == 'tar_tarifas'
		else
			case objeto.class.name
			when 'TarValorCuantia'
				controller_name == 'causas' and @options[:menu] == 'Antecedentes'
			when 'Registro'
				admin? and objeto.estado == 'ingreso'
			when 'MRegistro'
				btn == 'Editar' and ['m_periodos', 'm_items'].include?(controller_name)
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