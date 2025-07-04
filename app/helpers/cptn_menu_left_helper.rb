module CptnMenuLeftHelper
	## ------------------------------------------------------- MENU

	def scp_clnt(tkn, objeto)
		tab = tkn == :tar_facturas ? 'Facturas' : tkn.to_s.capitalize
		objeto.blank? ? '' : "/clientes/#{objeto.id unless objeto.blank?}?html_options[menu]=#{tab}&scp="
	end

	def scp_lnk(tkn, objeto)
		tkn == :clientes ? "/clientes?scp=" : (controller_name == 'clientes' ? scp_clnt(tkn, objeto) : "/#{tkn.to_s}?scp=")
	end

	def menu_left
		{
			admin: [
				{
					titulo: nil,
					condicion: perfil_activo?,
					items: [
						'AgeActividad',
					]
				},
				{
					titulo: nil,
					condicion: operacion?,
					items: [
						'Cliente',
						'Causa',
						'Asesoria'
					]
				},
				{
					titulo: nil,
					condicion: finanzas?,
					items: [
						'Cargo',
						'TarAprobacion',
						'TarFactura',
					]
				},
				{
					titulo: nil,
					condicion: admin?,
					items: [
						'Empresa',
					]
				},
				{
					titulo: 'Tablas',
					condicion: true,
					items: [
						{
							titulo: 'Causas & Asesorias',
							condicion: operacion?,
							items: [
								['Tribunales / Cortes', 'tribunal_corte']
							]
						},
						{
							titulo: 'Generales',
							condicion: admin?,
							items: [
								['UF & Regiones', 'uf_regiones'],
								['Enlaces', 'enlaces'],
								['Feriados', 'agenda']
							]
						},
						{
							titulo: 'Causas & Asesorias',
							condicion: admin?,
							items:  [
								['Etapas & Tipos', 'tipos'],
								['Cuantías', 'cuantias_tribunales'],
								['Tarifas generales', 'tarifas_generales'],
							]
						},
						{
							titulo: 'Modelo de Negocios',
							condicion: admin?,
							items: [
								['Modelo', 'modelo'],
								['Períodos & Bancos', 'periodos_bancos']
							]
						}
					]
				},
				{
					titulo: 'Ley Karin',
					condicion: admin?,
					items: [
						'Procedimiento',
						'Pautas'
					]
				},
				{
					titulo: 'Legal',
					condicion: admin?,
					items: [
						'LglDocumento',
						'DtMateria',
						'DtTablaMulta'
					]
				},
				{
					titulo: 'Administración', 
					condicion: admin?, 
					items: [
						'AppNomina',
						'Producto',
						'StModelo',
						'Variable'
					]
				},
				{
					titulo: 'App', 
					condicion: dog?, 
					items: [
						'AppVersion'
					]
				}
			],
			cuenta: [
				{
					titulo: nil,
					condicion: (perfil_activo?),
					items: [
						['KrnDenuncia', gscp(@objeto)],
						['KrnInvestigador', gscp(@objeto)],
						['KrnEmpresaExterna', gscp(@objeto)],
						['AppNomina', gscp(@objeto)],
					]
				},
			]
		}
	end

	def gscp(objeto)
		if objeto.blank?
			nil
		elsif ['Empresa', 'Cliente'].include?(objeto.class.name)
			@objeto
		elsif ['KrnDenuncia', 'KrnInvestigador', 'KrnEmpresaExterna', 'KrnDeclaracion'].include?(objeto.class.name)
			@objeto.ownr
		elsif ['KrnDenunciante', 'KrnDenunciado', 'KrnDerivacion', 'KrnInvDenuncia'].include?(objeto.class.name)
			@objeto.krn_denuncia.ownr
		elsif ['KrnTestigo'].include?(objeto.class.name)
			@objeto.ownr.krn_denuncia.ownr
		else
			nil
		end
	end

	def lm_exclude_action?
		controller_name == 'publicos' and (
				(['home', 'home_prueba'].include?(action_name) and current_usuario.blank?) or
				action_name == 'ayuda'
			)
	end

	def lm_exclude_controller?
		(['servicios']+ public_controllers + devise_controllers).include?(controller_name)
	end

	def ctas_cntrllrs?
		!!(controller_name =~ /^krn_[a-z_]*$/)  or ( ['cuentas'].include?(controller_name))
	end

	def lm_sym
		( lm_exclude_action? or lm_exclude_controller?) ? nil : (ctas_cntrllrs? ? :cuenta : :admin)
	end

	def itm_mdl(itm)
		itm.class.name == 'Array' ? itm[0] : itm
	end

	def cta_acctn(item, objeto)
		"#{objeto.class.name.tableize[0]}#{itm_mdl(item).constantize::ACCTN}"
	end

	def item_link(item)
		if itm_mdl(item) == 'Usuario'
			"/app_recursos/usuarios"
		elsif item.class.name == 'Array'
			"/cuentas/#{gscp(@objeto).id}/#{cta_acctn(item, gscp(@objeto))}"
		else
			"/#{itm_mdl(item).tableize}"
		end
	end

	# Determina el MODELO del ítem  dado el controlador desplegado
	def link_model(controller)
		if controller == 'app_recursos'
			"Usuario"
		else
			"#{controller.classify}"
		end
	end

	def itm_slctd?(modelo)
		if controller_name == 'cuentas'
			(['ednncs', 'cdnncs'].include?(action_name) and modelo[0] == 'KrnDenuncia') or (['einvstgdrs', 'cinvstgdrs'].include?(action_name) and modelo[0] == 'KrnInvestigador') or (['eextrns', 'cextrns'].include?(action_name) and modelo[0] == 'KrnEmpresaExterna')
		elsif modelo.class.name == 'Array'
			action_name == modelo[1]
		else
			controller_name.classify == modelo
		end
	end

	# Determina el ÍTEM dado el modelo del item
	def h_modelo_item
		{
			'AppNomina' => 'Nomina',
			'StModelo' => 'Personalización',
			'TarAprobacion' => 'Aprobaciones',
			'Asesoria' => 'Asesorías',
			'TarUfSistema' => 'UF del día',
			'Region' => 'Región',
			'AppEnlace' => 'Enlaces',
			'CalAnnio' => 'Calendario',
			'AgeUsuario' => 'Usuarios de agenda',
			'TipoCausa' => 'Etapas de Causas',
			'TipoServicio' => 'Tipos de Servicios',
			'TarDetalleCuantia' => 'Ítems de cuantía',
			'TribunalCorte' => 'Juzgados / Cortes',
			'TarTarifa' => 'Tarifas Generales',
			'MModelo' => 'Modelo de Negocios',
			'DtMateria' => 'Materias (Multas)',
			'KrnEmpresaExterna' => 'Empresas externas'
		}
	end

	def modelo_item(item)
		h_modelo_item[itm_mdl(item)].blank? ? to_name(itm_mdl(item)).tableize.capitalize : h_modelo_item[itm_mdl(item)]
	end

end