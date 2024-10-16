module Cmenu
	def cmenu_clss
		{
			'clientes' => {
				estados: [
					{
						std: 'activo',
						cndcn: operacion?
					},
					{
						std: 'baja',
						cndcn: admin?
					}
				],
				items: {
					'activo' => 'Activos',
					'baja' => 'Dados de baja'
				},
				selectors: [
					['Empresas', operacion?],
					['Sindicatos', operacion?],
					['Trabajadores', operacion?]
				]

			},
			'causas' => {
				estados: [
					{
						std: 'tramitación',
						cndcn: operacion?
					},
					{
						std: 'revisión',
						cndcn: admin?
					},
					{
						std: 'terminada',
						cndcn: operacion?
					},
					{
						std: 'cerrada',
						cndcn: general?
					}
				],
				items: {
					'tramitación' => 'En Tramitación',
					'terminada' => 'Terminadas',
					'cerrada' => 'Cerradas',
					'revisión' => 'Revisión',
					'por_facturar' => 'Por facturar'
				},
				selectors: [
					['por_facturar', admin?]
				]
			},
			'asesorias' => {
				estados: [
					{
						std: 'tramitación',
						cndcn: operacion?
					},
					{
						std: 'terminada',
						cndcn: operacion?
					},
					{
						std: 'cerrada',
						cndcn: finanzas?
					}
				],
				items: {
					'tramitación' => 'En Tramitación',
					'terminada' => 'Terminadas',
					'cerrada' => 'Cerradas',
					'CartaDespido' => 'Carta de despido'
				},
				selectors: [
					['Multas', admin?],
					['CartaDespido', admin?],
					['Redacciones', admin?],
					['Consultas', admin?]
				]
			},
			'cargos' => {
				estados: [
					{
						std: 'tramitación',
						cndcn: operacion?
					},
					{
						std: 'terminada',
						cndcn: operacion?
					},
					{
						std: 'cerrada',
						cndcn: finanzas?
					}
				],
				items: {
					'tramitación' => 'En Tramitación',
					'terminada' => 'Terminadas',
					'cerrada' => 'Cerradas'
				},
				selectors: [
					['Cargos', admin?],
					['Mensuales', admin?]
				]
			},
			'tar_facturas' => {
				estados: [
					{
						std: 'ingreso',
						cndcn: operacion?
					},
					{
						std: 'facturada',
						cndcn: operacion?
					},
					{
						std: 'pagada',
						cndcn: finanzas?
					}
				],
				items: {
					'ingreso' => 'Por facturar',
					'facturada' => 'Facturadas',
					'pagada' => 'Pagadas'
				},
				selectors: nil
			},
			'tar_tarifas' => {
				estados: nil,
				items: {
					'causas' => 'Tarifas de Causas',
					'asesorias' => 'Tarifas de asesorías'
				},
				selectors: [
					['causas', operacion?],
					['asesorias', operacion?]
				]
			},
			'denuncias' => {
				estados: [
					{
						std: 'recepción',
						cndcn: admin?
					},
					{
						std: 'diligencias',
						cndcn: admin?
					},
					{
						std: 'cierre',
						cndcn: admin?
					},
					{
						std: 'cerrada',
						cndcn: admin?
					}
				],
				items: {
					'recepción' => 'Recepcionadas',
					'diligencias' => 'Etapa de diligencias',
					'cierre' => 'Etapa de cierre',
					'cerrada' => 'Cerradas'
				},
				selectors: nil
			},
		}
	end

	def display_name(c, item)
		k_name = item.class.name == 'String' ? item : item[0]
		d_name = cmenu_clss[c][:items].blank? ? nil : cmenu_clss[c][:items][k_name]
		d_name.blank? ? k_name : d_name
	end

	def frst_std(cntrllr)
		stts = cmenu_clss[cntrllr][:estados]
		stts.blank? ? nil : stts.map {|st| st[:std] if st[:cndcn]}.compact.first
	end

	def frst_typ(cntrllr)
		slctrs = cmenu_clss[cntrllr][:selectors]
		slctrs.blank? ? nil : slctrs.map {|slctr| slctr[0] if slctr[1]}.compact.first
	end

	def std(cntrllr, prms_e, prms_t)
		(prms_e.blank? and prms_t.blank?) ? frst_std(cntrllr) : prms_e
	end

	def typ(cntrllr, prms_e, prms_t)
		(prms_t.blank? and std(cntrllr, prms_e, prms_t).blank?) ? frst_typ(cntrllr) : prms_t
	end

end